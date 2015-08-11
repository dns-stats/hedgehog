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

    def __init__(self, server_address, RequestHandlerClass, nodes, conn, server_name, key=None, keyname=None, keyalgo=None):
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
        self.db_server_name       = server_name
        
class DnsReaderHandler(SocketServer.BaseRequestHandler):
    '''
    Base Handler class 
    '''

    message  = None
    serial   = None
    data     = None
    incoming = None
    qname    = None

    def __init__(self, request, client_address, server):
        SocketServer.BaseRequestHandler.__init__(self, request, client_address, server)

    def _process_load_time(self):
        start = time.time()
        cur = self.server.conn.cursor()
        sql = "SELECT max(key2) FROM data WHERE key1=%s AND plot=%s AND server=%s"
        data = (self.qname, 'load_time', self.server.db_server_name)
        fsql = cur.mogrify(sql, data)
        self.server.logger.debug('SQL: {}'.format(fsql))
        # max_serial = db.session.query(db.func.max(models.Data.key2)).filter_by(
        #         key1=self.qname,
        #         plot=self.server.load_time_plot_model,
        #         server=self.server.server_model).first()[0]
        # if int(self.serial) <= int(max_serial):
        #     self.server.logger.debug('{}:{}:load-time already processed or lower then max({})'.format(
        #         self.qname, self.serial, max_serial))
        # else:
        #     zone_check = rssac.CheckZone(self.qname, self.server.nodes,
        #             self.serial, start)
        #     zone_check.check_propagation()
        #     for node, end in zone_check.nodes_report.items():
        #         if type(end) is str:
        #             load_time = end
        #         else:
        #             load_time = end - start
        #         node_model = models.Node.query.filter_by(name=node).first()
        #         if node_model:
        #             self.server.logger.debug('Adding:{}:{}:load-time: {}'.format(
        #                 self.qname, self.serial, load_time))
        #             data_model = models.Data(
        #                     starttime=datetime.datetime.fromtimestamp(start), key1=self.qname,
        #                     key2=self.serial, value=load_time,
        #                     plot=self.server.load_time_plot_model,
        #                     server=self.server.server_model,
        #                     node=node_model)
        #             db.session.add(data_model)
        #         else:
        #             self.server.logger.error('{}:Not in db'.format(node))

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

    def parse_dns(self):
        '''
        parse the data package into dns elements
        '''
        self.data = str(self.request[0]).strip()
        self.incoming = self.request[1]
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
                    return True
                else:
                    self.server.logger.error('Received notify with no serial from {}'.format(self.client_address[0]))
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
        
def check_db_get_nodes(server, conn):
    logger = logging.getLogger('rssac_propagation.server')
    nodes = {}

    cur = conn.cursor()
    
    sql = "SELECT count(*) FROM plot where name='load_time'"
    logger.debug('SQL: {}'.format(sql))
    cur.execute(sql)
    load_time = cur.fetchone()
    if load_time[0] != 1:
        scur.close()
        raise ValueError('load_time is not defined in the plot table')
    logger.debug('load_time is supported by the database')
    
    sql = "SELECT count(*) FROM plot where name='zone_size'"
    logger.debug('SQL: {}'.format(sql))
    cur.execute(sql)
    zone_size = cur.fetchone()
    if zone_size[0] != 1:
        cur.close()
        raise ValueError('zone_size is not defined in the plot table')
    logger.debug('zone_size is supported by the database')
    
    sql = "SELECT id from server where name=%s;"
    data = (server, )
    fsql = cur.mogrify(sql, data)
    logger.debug('SQL: {}'.format(fsql))
    cur.execute(sql, data)
    server_id = cur.fetchone()
    if server_id == None:
        cur.close()
        raise ValueError('Server is not defined in the database')
    logger.debug('SQL Result: Server {} has id {}'.format(server, server_id[0]))
    
    sql="SELECT name, '10.0.1.12' as ip FROM node WHERE server_id=%s"
    data = (server_id[0], )
    fsql = cur.mogrify(sql, data)
    logger.debug('SQL: {}'.format(fsql))
    cur.execute(sql, data)
    for node in cur:
        nodes[node[0]] = node[1]
    cur.close()
    if not nodes:
        raise ValueError('No nodes found for server {}'.format(server))
    logger.debug('SQL Result: Server {} has node(s) {}'.format(server, nodes))
    return nodes
    
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
    
    ''' Get the list of nodes to query '''
    nodes = check_db_get_nodes(args.server, conn)
    
    ''' Init and then run the server '''
    server = DnsReaderServer((host, int(port)), DnsReaderHandler, nodes, conn, args.server,
            args.tsig_key, args.tsig_name, args.tsig_algo) 
    server.serve_forever()
    conn.close()
    
if __name__ == "__main__":
    main()