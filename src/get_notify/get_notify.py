#!/usr/bin/env python
import sys
import time
import rssac
import socket
import argparse
import datetime
import logging
import StringIO
import SocketServer
import dns.name
import dns.tsig
import dns.query
import dns.message
import dns.tsigkeyring
import psycopg2

class DnsReaderServer(SocketServer.UDPServer):
    '''
    SocketServer.ThreadingUDPServer 

    Instance variables:
    
    - RequestHandlerClass
    '''

    keyname   = None
    keyring   = None

    def __init__(self, server_address, RequestHandlerClass, nodes, conn, server_id, key=None, keyname=None, keyalgo=None):
        SocketServer.UDPServer.__init__(
                self, server_address, RequestHandlerClass)
        
        self.logger = logging.getLogger('rssac_propagation.server.DnsReaderServer')
        self.nodes                = nodes
        if key and keyname:
            self.keyname          = keyname
            self.keyring          = dns.tsigkeyring.from_text({ keyname : key})
        if keyalgo:
            self.keyalgorithm     = dns.name.from_text(keyalgo)
        self.conn                 = conn
        self.db_server_id         = server_id
        
class DnsReaderHandler(SocketServer.BaseRequestHandler):
    '''
    Base Handler class 
    '''

    message  = None
    serial   = None
    data     = None
    socket   = None
    qname    = None

    def __init__(self, request, client_address, server):
        SocketServer.BaseRequestHandler.__init__(self, request, client_address, server)

    def _get_plot_id(self, plot_name):
        logger = logging.getLogger('rssac_propagation.server')

        cur = self.server.conn.cursor()
    
        sql = "SELECT id from plot where name=%s;"
        data = (plot_name, )
        fsql = cur.mogrify(sql, data)
        logger.debug('SQL Query: {}'.format(fsql))
        cur.execute(sql, data)
        plot_id = cur.fetchone()
        if plot_id == None:
            cur.close()
            raise ValueError('Plot is not defined in the database')
        logger.debug('SQL Result: Plot {} has id {}'.format(plot_name, plot_id[0]))
    
        cur.close()
        return plot_id[0]

    def _process_load_time(self):
        start = time.time()
        plot_id = self._get_plot_id('load_time')
        cur = self.server.conn.cursor()
        sql = "SELECT max(data.key2) FROM data, plot WHERE data.key1=%s AND plot.name=%s AND plot.id=data.plot_id AND server_id=%s"
        data = (self.qname, 'load_time', self.server.db_server_id)
        fsql = cur.mogrify(sql, data)
        self.server.logger.debug('SQL: {}'.format(fsql))
        cur.execute(sql, data)
        max_serial_tuple = cur.fetchone()
        if max_serial_tuple[0] == None:
            max_serial=0
        else:
            max_serial=max_serial_tuple[0]
            
        self.server.logger.debug('SQL Result: Server id {} has max serial {}'.format(self.server.db_server_id, max_serial))
        if int(self.serial) <= int(max_serial):
            self.server.logger.debug('{}:{}:load-time already processed or lower then max({})'.format(
                self.qname, self.serial, max_serial))
        else:
            zone_check = rssac.CheckZone(self.qname, self.server.nodes,
                    self.serial, start)
            zone_check.check_propagation()
            for node, end in zone_check.nodes_report.items():
                if type(end) is str:
                    load_time = end
                else:
                    load_time = end - start                    
                sql = "INSERT INTO data (starttime, server_id, node_id, plot_id, key1, key2, value) VALUES (%s,%s,%s,%s,%s,%s,%s)"
                data = (datetime.datetime.fromtimestamp(start), self.server.db_server_id, node, plot_id, self.qname, self.serial, load_time)
                fsql = cur.mogrify(sql, data)
                self.server.logger.debug('SQL: {}'.format(fsql))
                cur.execute(sql, data)
        
        cur.close()
        
    def _get_zone_size(self):
        zone      = StringIO.StringIO()
        xfr       = dns.query.xfr(self.client_address[0], self.qname, keyname=self.server.keyname, 
                keyring=self.server.keyring, keyalgorithm=self.server.keyalgorithm)
        for message in xfr:
            for ans in message.answer:
                ans.to_wire(zone, origin=dns.name.root)
        return sys.getsizeof(zone.getvalue())

    def _process_zone_size(self):
        start      = time.time()
        max_serial = db.session.query(db.func.max(models.Data.key2)).filter_by(
                key1=self.qname,
                plot=self.server.zone_size_plot_model,
                server=self.server.server_model).first()[0]
        if int(self.serial) <= int(max_serial):
            self.server.logger.debug('{}:{}:serial already processed or lower then max({})'.format(
                self.qname, self.serial, max_serial))
        else:
            zone_size = self._get_zone_size()
            for node in self.server.nodes.keys():
                node_model = models.Node.query.filter_by(name=node).first()
                if node_model:
                    self.server.logger.debug('Adding:{}:{}:zone-size: {}'.format(
                        self.qname, self.serial, zone_size))
                    data_model = models.Data(
                            starttime=datetime.datetime.fromtimestamp(start), key1=self.qname,
                            key2=self.serial, value=zone_size,
                            plot=self.server.zone_size_plot_model, 
                            server=self.server.server_model, 
                            node=node_model)
                    db.session.add(data_model)
                else:
                    self.server.logger.error('{}:Not in db'.format(node))
                    
    def send_response(self):
        ''' Send notify response '''
        response = dns.message.make_response(self.message)
        self.socket.sendto(response.to_wire(), self.client_address)
        
    def parse_dns(self):
        '''
        parse the data package into dns elements
        '''
        self.data = str(self.request[0]).strip()
        self.socket = self.request[1]
        #incoming Data
        try:
            self.message = dns.message.from_wire(self.data)
        except dns.name.BadLabelType:
            #Error processing lable (bit flip?)
            self.server.logger.error('Received Bad label Type from {}'.format(self.client_address[0]))
        except dns.message.ShortHeader:
            #Received junk
            self.server.logger.error('Received Junk from {}'.format(self.client_address[0]))
        else:
            current_time = int(time.time())
            if self.message.opcode() == 4:
                self.qname = self.message.question[0].name.to_text()
                if len(self.message.answer) > 0:
                    answer = self.message.answer[0]
                    self.serial = answer.to_rdataset()[0].serial
                    self.server.logger.debug('Received notify for {} from {}'.format(self.serial, self.client_address[0]))
                    self.send_response()
                    return True
                else:
                    self.server.logger.error('Received notify with no serial from {}'.format(self.client_address[0]))
                    self.send_response()
        return False

    def handle(self):
        '''
        RequestHandlerClass handle function
        handler listens for dns packets
        '''
        if self.parse_dns():
            self._process_load_time()
        '''self._process_zone_size()
        db.session.commit()
        '''
        
def get_nodes(server_id, conn):
    logger = logging.getLogger('rssac_propagation.server')
    nodes = {}

    cur = conn.cursor()
    
    sql="SELECT id, '192.168.1.148' as ip FROM node WHERE server_id=%s"
    data = (server_id, )
    fsql = cur.mogrify(sql, data)
    logger.debug('SQL: {}'.format(fsql))
    cur.execute(sql, data)
    for node in cur:
        nodes[node[0]] = node[1]
    cur.close()
    if not nodes:
        raise ValueError('No nodes found for server id {}'.format(server_id))
    logger.debug('SQL Result: Server id {} has node(s) id {}'.format(server_id, nodes))
    return nodes

def check_db(conn):
    logger = logging.getLogger('rssac_propagation.server')

    cur = conn.cursor()
    
    sql = "SELECT count(*) FROM plot where name='load_time'"
    logger.debug('SQL Query: {}'.format(sql))
    cur.execute(sql)
    load_time = cur.fetchone()
    if load_time[0] != 1:
        scur.close()
        raise ValueError('load_time is not defined in the plot table')
    logger.debug('SQL Result: load_time is supported by the database')
    
    sql = "SELECT count(*) FROM plot where name='zone_size'"
    logger.debug('SQL Query: {}'.format(sql))
    cur.execute(sql)
    zone_size = cur.fetchone()
    if zone_size[0] != 1:
        cur.close()
        raise ValueError('zone_size is not defined in the plot table')
    logger.debug('SQL Result: zone_size is supported by the database')
    
    cur.close()
    return True

def get_server_id(server_name, conn):
    logger = logging.getLogger('rssac_propagation.server')

    cur = conn.cursor()
    
    sql = "SELECT id from server where name=%s;"
    data = (server_name, )
    fsql = cur.mogrify(sql, data)
    logger.debug('SQL Query: {}'.format(fsql))
    cur.execute(sql, data)
    server_id = cur.fetchone()
    if server_id == None:
        cur.close()
        raise ValueError('Server is not defined in the database')
    logger.debug('SQL Result: Server {} has id {}'.format(server_name, server_id[0]))
    
    cur.close()
    return server_id[0]
    
def main():
    ''' parse cmd line args '''
    parser = argparse.ArgumentParser(description='nofify receiver')
    parser.add_argument('--tsig-name')
    parser.add_argument('--tsig-key')
    parser.add_argument('--tsig-algo', 
            choices=['hmac-sha1', 'hmac-sha224', 'hmac-sha256', 'hmac-sha384','hmac-sha512'])
    parser.add_argument('-v', '--verbose', action='count', help='Increase verbosity')
    parser.add_argument('--log', default='server.log')
    parser.add_argument('-l', '--listen', metavar="0.0.0.0:53", 
            default="0.0.0.0:53", help='listen on address:port ')
    parser.add_argument('-s','--server', help='Server name', required=True)
    args = parser.parse_args()
    host, port = args.listen.split(":")
    
    ''' configure logging '''
    log_level = logging.ERROR
    log_format ='%(asctime)s:%(levelname)s:%(name)s:%(funcName)s(%(levelno)s):%(message)s'
    if args.verbose == 1:
        log_level = logging.WARN
    elif args.verbose == 2:
        log_level = logging.INFO
    elif args.verbose > 2:
        log_level = logging.DEBUG
    logging.basicConfig(level=log_level, filename=args.log, format=log_format)
    
    ''' Set up database connection '''
    ''' TODO: Read the conf file '''
    conn = psycopg2.connect("dbname=hedgehog user=hedgehog")
    
    ''' Check databasse knows about load_time and zone_size '''
    check_db(conn)    
    
    ''' Get server id from database '''
    server_id = get_server_id(args.server, conn)
    
    ''' Get the list of nodes to query '''
    nodes = get_nodes(server_id, conn)
    
    ''' Init and then run the server '''
    server = DnsReaderServer((host, int(port)), DnsReaderHandler, nodes, conn, server_id,
            args.tsig_key, args.tsig_name, args.tsig_algo) 
    server.serve_forever()
    
    conn.close()
    
if __name__ == "__main__":
    main()