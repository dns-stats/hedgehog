#!/usr/bin/env python
import argparse
import os
import glob
import yaml
import time
import sys
import dns.query
import dns.message
import dns.rdatatype
import dns.exception
import logging
import threadpool

class CheckZone(object):
    def __init__(self, zone, nodes, serial, start_period):
        self.zone          = zone
        self.master_serial = serial
        self.nodes         = nodes
        self.start_period  = start_period
        self.node_cnt      = len(nodes)
        self.nodes_report  = {}
        logging.debug('INIT:{} = {}'.format(self.zone, self.master_serial))

    def _get_serial(self, nameserver):
        logging.debug('fetching: {}@{}'.format(self.zone, nameserver))
        request = dns.message.make_query(self.zone, dns.rdatatype.SOA)
        try:
            ''' The timeout might need tuning '''
            response = dns.query.udp(request, nameserver, timeout=.25)
        except dns.exception.Timeout:
            logging.error('Timeout from {}@{}'.format(self.zone, nameserver))
            return False
        else:
            return response.answer[0].to_text().split()[6]

    def _check_serial(self, node_dict):
        ''' TODO: Serial number arithmetic? '''
        node = node_dict.items()[0][0]
        addr = node_dict.items()[0][1]
        node_serial = self._get_serial(addr)
        porpagation_time = False
        logging.debug('SERIAL:{}@{} = {}'.format(self.zone, addr, node_serial))
        if node_serial == str(self.master_serial):
            porpagation_time = time.time()
            logging.info('SERIAL:{}@{} == {} @ {}'.format(self.zone, addr, node_serial, 
                porpagation_time))
        elif node_serial > str(self.master_serial):
            logging.debug('SERIAL:{}@{} {} > {} @ {}'.format(self.zone, addr, node_serial, 
                self.master_serial, time.time() ))
            porpagation_time = time.time()
        elif not node_serial:
            porpagation_time = 'Timeout'
        else:
            logging.debug('SERIAL:{}@{} {} != {} @ {}'.format(self.zone, addr, node_serial, 
                self.master_serial, time.time() ))
        return (node, porpagation_time)


    def _thread_callback(self, request, porpagation_time_tuple):
        node = porpagation_time_tuple[0]
        porpagation_time = porpagation_time_tuple[1]
        if porpagation_time:
            self.nodes_report[node] = porpagation_time

    def check_propagation(self):
        ''' Create threadpool before while loop and destroy it after the loop
            or you get a thread leak! '''
        main = threadpool.ThreadPool(self.node_cnt)
        while self.node_cnt != len(self.nodes_report):
            data = [ dict({node : self.nodes[node]}) for node in self.nodes 
                    if node not in self.nodes_report ]
            requests = threadpool.makeRequests(self._check_serial, 
                    data, self._thread_callback)
            [main.putRequest(req) for req in requests]
            main.wait()
            logging.info('processed: {}/{}'.format(len(self.nodes_report), self.node_cnt))
            if self.node_cnt != len(self.nodes_report):
                ''' Report resolution is in seconds so sleep for a bit '''
                time.sleep(0.25)
        main.dismissWorkers(self.node_cnt,True)
        logging.info('{}: processed propagation:'.format(self.zone))
 
def get_enabled_hosts(yaml_dir):
    nodes = {}
    for document in glob.glob(os.path.join(yaml_dir, '*.l.root-servers.org.yaml')):
        node_name = os.path.basename(document).split('.')[0]
        document = file(document, 'r')
        yaml_obj = yaml.load(document)
        logging.debug('YAML:ADD:{}'.format(node_name))
        if not yaml_obj['status']['operational']:
            continue
        for interface, config in yaml_obj['network::interfaces'].items():
            if 'gw4' in config:
                nodes[node_name] = config['addr4'].split('/')[0]
                break
    return nodes


def parse_args():
    parser = argparse.ArgumentParser(description=__doc__)
    parser = argparse.ArgumentParser(description='Preform RSSAC propogation measurment')
    parser.add_argument('--yaml-dir', default='/etc/hierdata/icann-nodes/')
    parser.add_argument('-v', '--verbose', action='count')
    parser.add_argument('zone')
    return parser.parse_args()

def main():
    args      = parse_args()
    log_level = logging.ERROR
    nodes     = get_enabled_hosts(args.yaml_dir)

    if args.verbose == 1:
        log_level = logging.WARN
    elif args.verbose == 2:
        log_level = logging.INFO
    elif args.verbose == 3:
        log_level = logging.DEBUG
    logging.basicConfig(level=log_level)
    



if __name__ == "__main__":
    main()
