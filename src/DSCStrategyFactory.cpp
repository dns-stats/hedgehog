/* 
 * Copyright 2014 Internet Corporation for Assigned Names and Numbers.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*
 * Developed by Sinodun IT (www.sinodun.com)
 */

/* 
 * File:   DSCStrategyFactory.cpp
 */

// TODO(refactor): This should be re-factored and pick up the data from a config file. 
// TODO(refactor): A config file should also be used to specify which data to process and which to ignore.

#include <iostream>
#include <string>
#include <vector>
#include "dsc_types.h"
#include "DSCStrategyFactory.h"
#include "DSCStrategy.h"
#include "Format1DSCStrategy.h"
#include "Format2DSCStrategy.h"
#include "Format3aDSCStrategy.h"
#include "Format3bDSCStrategy.h"
#include "Format4DSCStrategy.h"

using namespace std;

DSCStrategyFactory::DSCStrategyFactory() {

}

DSCStrategyFactory::~DSCStrategyFactory() {

}

vector<DSCStrategy*>
DSCStrategyFactory::createStrategy(const string &server, const string &name, bool rssac) {

    vector<DSCStrategy*> return_v;

    //  Format 1
    if (name.compare("rcode") == 0) {
        string keys[1] = { "dummy" };
        Format1DSCStrategy* strat = new Format1DSCStrategy(server, name, keys,0);
        return_v.push_back( strat );
        return return_v;
        
    } else if (name.compare("server_addr") == 0) {
        string keys[1] = { "dummy" };
        Format1DSCStrategy* strat = new Format1DSCStrategy(server, name, keys,0);
        return_v.push_back( strat );
        return return_v;
        
    } else if (name.compare("qtype") == 0) {
        string keys[11] = { "1", "2", "5", "6", "12", "15", "28", "33",
                                "38", "255",  "else"};
        Format1DSCStrategy* strat = new Format1DSCStrategy(server, name,keys,11);
        return_v.push_back( strat );
        
        string keys1[8] = {"24", "25", "30", "43", "46", "47", "50", "48"};
        Format1DSCStrategy* strat1 = new Format1DSCStrategy(server,"dnssec_qtype",keys1,8);
        return_v.push_back( strat1 );
        return return_v;        
    
    } else if (name.compare("opcode") == 0) {
        string keys[6] = {"0", "1", "2", "4", "5", "else"};
        Format1DSCStrategy* strat = new Format1DSCStrategy(server, name,keys,6);
        return_v.push_back( strat );
        return return_v;
        
    } else if (name.compare("edns_version") == 0) {
        string keys[3] = {"none", "0", "else"};
        Format1DSCStrategy* strat = new Format1DSCStrategy(server, name,keys,3);
        return_v.push_back( strat );
        return return_v;
        
    } else if (name.compare("rd_bit") == 0) {
        string keys[2] = {"set", "clr"};
        Format1DSCStrategy* strat = new Format1DSCStrategy(server, name,keys,2);
        return_v.push_back( strat );
        return return_v;
        
    } else if (name.compare("idn_qname") == 0) {
        string keys[2] = {"normal", "idn"};
        Format1DSCStrategy* strat = new Format1DSCStrategy(server, name,keys,2);
        return_v.push_back( strat );
        return return_v;
        
    } else if (name.compare("do_bit") == 0) {
        string keys[2] = {"set", "clr"};
        Format1DSCStrategy* strat = new Format1DSCStrategy(server, name,keys,2);
        return_v.push_back( strat );
        return return_v;
    //  End Format 1

    //  Format 2
    } else if (name.compare("certain_qnames_vs_qtype") == 0) {
        string keys[11] = {"1", "2", "5", "6", "12", "15", "28", "33",
                                "38", "255", "else"};
        Format2DSCStrategy* strat = new Format2DSCStrategy(server, name,keys,11);
        return_v.push_back( strat );
        return return_v;
    
    } else if (name.compare("direction_vs_ipproto") == 0) {
        string keys[3] = {"icmp", "tcp", "udp"};
        Format2DSCStrategy* strat = new Format2DSCStrategy(server, name,keys,3);
        return_v.push_back( strat );
        return return_v;
        
    } else if (name.compare("chaos_types_and_names") == 0) {
        string keys[3] = {"hostname.bind", "version.bind", "other"};
        Format2DSCStrategy* strat = new Format2DSCStrategy(server, name,keys,3);
        return_v.push_back( strat );
        return return_v;
    
    } else if (name.compare("pcap_stats") == 0) {
        string keys[1] = {"dummy"};
        Format2DSCStrategy* strat = new Format2DSCStrategy(server, name,keys,0);
        return_v.push_back( strat );
        return return_v;

    } else if (name.compare("transport_vs_qtype") == 0) {
        string keys[11] = {"1", "2", "5", "6", "12", "15", "28", "33",
                                "38", "255", "else"};
        Format2DSCStrategy* strat = new Format2DSCStrategy(server, name,keys,11);
        return_v.push_back( strat );
        return return_v;
    } else if ( name.compare("traffic_volume_queries") == 0 ||
        name.compare("traffic_volume_responses") == 0 ) {
        if (rssac) {
            string keys[1]= { "dummy" };
            Format2DSCStrategy* strat = new Format2DSCStrategy(server, name, keys,0);
            return_v.push_back( strat );
            return return_v;        
        } else {
            return return_v;
    }
    //  End Format 2 
       
    //  Format 3
    } else if (name.compare("client_subnet") == 0) {
        string keys[1] = {"dummy"};
        Format3aDSCStrategy* strat = new Format3aDSCStrategy(server, "client_subnet_count",keys,0);
        return_v.push_back( strat );
        Format3bDSCStrategy* strat1 = new Format3bDSCStrategy(server, "client_subnet_accum",keys,0);
        return_v.push_back( strat1 );
        return return_v;
      
    } else if (name.compare("idn_vs_tld") == 0) {
        string keys[1] = {"dummy"};
        Format3bDSCStrategy* strat = new Format3bDSCStrategy(server, name,keys,0);
        return_v.push_back( strat );
        return return_v;
    
    } else if (name.compare("ipv6_rsn_abusers") == 0) {
        string keys[1] = {"dummy"};
        Format3aDSCStrategy* strat = new Format3aDSCStrategy(server, "ipv6_rsn_abusers_count",keys,0);
        return_v.push_back( strat );        
        Format3bDSCStrategy* strat1 = new Format3bDSCStrategy(server,"ipv6_rsn_abusers_accum",keys,0);
        return_v.push_back( strat1 );
        return return_v;

    } else if (name.compare("traffic_sizes_queries") == 0 ||
        name.compare("traffic_sizes_responses") == 0) {
        if (rssac) {
            string keys[1] = {"dummy"};
            Format3bDSCStrategy* strat = new Format3bDSCStrategy(server, name,keys,0);
            return_v.push_back( strat );
            return return_v;
        } else {
            return return_v;
        }

    } else if (name.compare("unique_sources") == 0) {
        if (rssac) {
            string keys[1] = {"dummy"};
            Format3bDSCStrategy* strat = new Format3bDSCStrategy(server, "unique_sources_raw",keys,0);
            return_v.push_back( strat );
            return return_v;    
        } else {
            return return_v;   
        }
    //  End Format 3
        
    //  Format 4
    } else if (name.compare("qtype_vs_tld") == 0) {
        string keys[11] = {"1", "2", "5", "6", "12", "15", "28", "33",
                                "38", "255", "else"};
        Format4DSCStrategy* strat = new Format4DSCStrategy(server, name,keys,11);
        return_v.push_back( strat );
        return return_v;
        
    } else if (name.compare("client_addr_vs_rcode") == 0) {
        string keys[1] = {"dummy"};
        Format4DSCStrategy* strat = new Format4DSCStrategy(server,"client_addr_vs_rcode_accum",keys,0);
        return_v.push_back( strat );
        return return_v;
        
    } else if (name.compare("qtype_vs_qnamelen") == 0) {
        string keys[1] = {"dummy"};
        Format4DSCStrategy* strat = new Format4DSCStrategy(server, name,keys,0);
        return_v.push_back( strat );
        return return_v;
        
    } else if (name.compare("rcode_vs_replylen") == 0) {
        string keys[1] = {"dummy"};
        Format4DSCStrategy* strat = new Format4DSCStrategy(server, name,keys,0);
        return_v.push_back( strat );
        return return_v;       
        
    } else if (name.compare("client_subnet_vs_tld") == 0) {
        string keys[1] = {"dummy"};
        Format4DSCStrategy* strat = new Format4DSCStrategy(server, name,keys,0);
        return_v.push_back( strat );
        return return_v;
        
    //  End format 4
        
    //  Multiple formats        
    } else if (name.compare("client_subnet2") == 0) {
        string keys[11] = {"ok", "non-auth-tld", "root-servers.net",
                                "localhost", "a-for-a", "a-for-root",
                                "rfc1918-ptr", "funny-qclass", "funny-qtype", 
                                "src-port-zero", "malformed"};
        Format1DSCStrategy* strat = new Format1DSCStrategy(server,"client_subnet2_trace",keys,11);
        return_v.push_back( strat );
        
        Format1DSCStrategy* strat1 = new Format1DSCStrategy(server,"client_subnet2_count",keys,11);
        return_v.push_back( strat1 );
        
        Format4DSCStrategy* strat2 = new Format4DSCStrategy(server,"client_subnet2_accum",keys,11);
        return_v.push_back( strat2 );
        return return_v;
        
    } else if (name.compare("dns_ip_version_vs_qtype") == 0) {
        string keys[11] = {"1", "2", "5", "6", "12", "15", "28", "33",
                                "38", "255", "else"};
        Format2DSCStrategy* strat = new Format2DSCStrategy(server,"dns_ip_version",keys,11);
        return_v.push_back( strat );
        
        Format4DSCStrategy* strat1 = new Format4DSCStrategy(server,"dns_ip_version_vs_qtype",keys,11);
        return_v.push_back( strat1 );
        return return_v;
    //  End Multiple formats

    } else {
        // return empty vector
        return return_v;
    }

}

vector<DSCStrategy*>
DSCStrategyFactory::createStrategyDat(const string &server, const string &name) {

    vector<DSCStrategy*> return_v;
    string keys[1] = {"dummy"};

    //  Format 1    
    if (name.compare("rcode.dat") == 0) {
        Format1DSCStrategy* strat = new Format1DSCStrategy(server,"rcode", keys,0);
        return_v.push_back( strat );
        return return_v;
        
    } else if (name.compare("qtype.dat") == 0) {
        Format1DSCStrategy* strat = new Format1DSCStrategy(server,"qtype",keys,0);
        return_v.push_back( strat );
        return return_v;        
    
    } else if (name.compare("dnssec_qtype.dat") == 0) {
        Format1DSCStrategy* strat = new Format1DSCStrategy(server,"dnssec_qtype",keys,0);
        return_v.push_back( strat );
        return return_v;
    
    } else if (name.compare("opcode.dat") == 0) {
        Format1DSCStrategy* strat = new Format1DSCStrategy(server,"opcode",keys,0);
        return_v.push_back( strat );
        return return_v;
        
    } else if (name.compare("edns_version.dat") == 0) {
        Format1DSCStrategy* strat = new Format1DSCStrategy(server,"edns_version",keys,0);
        return_v.push_back( strat );
        return return_v;
        
    } else if (name.compare("rd_bit.dat") == 0) {
        Format1DSCStrategy* strat = new Format1DSCStrategy(server,"rd_bit",keys,0);
        return_v.push_back( strat );
        return return_v;
        
    } else if (name.compare("idn_qname.dat") == 0) {
        Format1DSCStrategy* strat = new Format1DSCStrategy(server,"idn_qname",keys,0);
        return_v.push_back( strat );
        return return_v;        
        
    } else if (name.compare("do_bit.dat") == 0) {
        Format1DSCStrategy* strat = new Format1DSCStrategy(server,"do_bit",keys,0);
        return_v.push_back( strat );
        return return_v;
    //  End Format 1 

    //  Format 2
    } else if (name.compare("certain_qnames_vs_qtype.dat") == 0) {
        Format2DSCStrategy* strat = new Format2DSCStrategy(server,"certain_qnames_vs_qtype",keys,0);
        return_v.push_back( strat );
        return return_v;
    
    } else if (name.compare("direction_vs_ipproto.dat") == 0) {
        Format2DSCStrategy* strat = new Format2DSCStrategy(server,"direction_vs_ipproto",keys,0);
        return_v.push_back( strat );
        return return_v;
        
    } else if (name.compare("chaos_types_and_names.dat") == 0) {
        Format2DSCStrategy* strat = new Format2DSCStrategy(server,"chaos_types_and_names",keys,0);
        return_v.push_back( strat );
        return return_v;
    
    } else if (name.compare("pcap_stats.dat") == 0) {
        Format2DSCStrategy* strat = new Format2DSCStrategy(server,"pcap_stats",keys,0);
        return_v.push_back( strat );
        return return_v;

    } else if (name.compare("transport_vs_qtype.dat") == 0) {
        Format2DSCStrategy* strat = new Format2DSCStrategy(server,"transport_vs_qtype",keys,0);
        return_v.push_back( strat );
        return return_v;
    //  End Format 2 

    //  Format 3
    } else if (name.compare("client_subnet_count.dat") == 0) {
        Format3aDSCStrategy* strat = new Format3aDSCStrategy(server,"client_subnet_count",keys,0);
        return_v.push_back( strat );
        return return_v;
        
    } else if (name.compare("client_subnet_accum.dat") == 0) {
        Format3bDSCStrategy* strat = new Format3bDSCStrategy(server,"client_subnet_accum",keys,0);
        return_v.push_back( strat );
        return return_v;
        
    } else if (name.compare("idn_vs_tld.dat") == 0) {
        Format3bDSCStrategy* strat = new Format3bDSCStrategy(server,"idn_vs_tld",keys,0);
        return_v.push_back( strat );
        return return_v;
        
    } else if (name.compare("ipv6_rsn_abusers_count.dat") == 0) {
        Format3aDSCStrategy* strat = new Format3aDSCStrategy(server,"ipv6_rsn_abusers_count",keys,0);
        return_v.push_back( strat );
        return return_v;
        
    } else if (name.compare("ipv6_rsn_abusers_accum.dat") == 0) {
        Format3bDSCStrategy* strat = new Format3bDSCStrategy(server,"ipv6_rsn_abusers_accum",keys,0);
        return_v.push_back( strat );
        return return_v;
    //  End Format 3

    //  Format 4
    } else if (name.compare("qtype_vs_tld.dat") == 0) {
        Format4DSCStrategy* strat = new Format4DSCStrategy(server,"qtype_vs_tld",keys,0);
        return_v.push_back( strat );
        return return_v;
        
    } else if (name.compare("client_addr_vs_rcode_accum.dat") == 0) {
        Format4DSCStrategy* strat = new Format4DSCStrategy(server,"client_addr_vs_rcode_accum",keys,0);
        return_v.push_back( strat );
        return return_v;
        
    } else if (name.compare("qtype_vs_qnamelen.dat") == 0) {
        Format4DSCStrategy* strat = new Format4DSCStrategy(server,"qtype_vs_qnamelen",keys,0);
        return_v.push_back( strat );
        return return_v;
        
    } else if (name.compare("rcode_vs_replylen.dat") == 0) {
        Format4DSCStrategy* strat = new Format4DSCStrategy(server,"rcode_vs_replylen",keys,0);
        return_v.push_back( strat );
        return return_v;
    //  End format 4
        
    //  Multiple formats
    } else if (name.compare("client_subnet2_trace.dat") == 0) {
        Format1DSCStrategy* strat = new Format1DSCStrategy(server,"client_subnet2_trace",keys,0);
        return_v.push_back( strat );
        return return_v;
    
    } else if (name.compare("client_subnet2_count.dat") == 0) {
        Format1DSCStrategy* strat = new Format1DSCStrategy(server,"client_subnet2_count",keys,0);
        return_v.push_back( strat );
        return return_v;
        
    } else if (name.compare("client_subnet2_accum.dat") == 0) {
        Format4DSCStrategy* strat = new Format4DSCStrategy(server,"client_subnet2_accum",keys,0);
        return_v.push_back( strat );
        return return_v;
        
    } else if (name.compare("dns_ip_version_vs_qtype.dat") == 0) {
        Format4DSCStrategy* strat = new Format4DSCStrategy(server,"dns_ip_version_vs_qtype",keys,0);
        return_v.push_back( strat );
        return return_v;
        
    } else if (name.compare("dns_ip_version.dat") == 0) {
        Format2DSCStrategy* strat = new Format2DSCStrategy(server,"dns_ip_version",keys,0);
        return_v.push_back( strat );
        return return_v;
    //  End Multiple formats

    } else {
        // return empty vector
        return return_v;
    }

}
