/* 
 * Copyright 2014 Internet Corporation for Assigned Names and Numbers.
 * 
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, you can obtain one at https://mozilla.org/MPL/2.0/.
 */

/*
 * Developed by Sinodun IT (www.sinodun.com)
 */

#include <iostream>
#include <map>
#include <string>

#define BOOST_FILESYSTEM_NO_DEPRECATED
#include <boost/filesystem.hpp>
#include <boost/filesystem/fstream.hpp>
#include <boost/tokenizer.hpp>
#include "dsc_types.h"
#include "Format1DSCStrategy.h"
#include "DSCStrategy.h"

#include "pqxx/pqxx"

using namespace std;
namespace bfs = boost::filesystem;

//
// time k1 v1 k2 v2 ...
//

Format1DSCStrategy::Format1DSCStrategy(string server, string name, string keys[], int keylength) : DSCStrategy(server, name, keys, keylength) {
    
}

void
Format1DSCStrategy::preprocess_data(const DSCUMap &orig_dscdata, DSCUMap &new_dscdata, string /*dtime*/[], int /*server*/, int /*node*/, pqxx::work* /*pg_db_trans*/) {
    
    if ( plot_name_ == "client_subnet2_count") {
        accum2d_to_count(orig_dscdata, new_dscdata);
    } else if ( plot_name_ == "client_subnet2_trace") {
        accum2d_to_trace(orig_dscdata, new_dscdata);
    } else if ( plot_name_ == "client_port_range" || 
                plot_name_ == "edns_bufsiz"  ||
                plot_name_ == "rcode" ||
                plot_name_ == "server_addr") {
        new_dscdata = orig_dscdata;
    } else {
        new_dscdata = orig_dscdata;
        elsify_unwanted_keys(new_dscdata);    
    }

}

void
Format1DSCStrategy::process_to_dat(const DSCUMap &dscdata, string dtime[]) {

    open_file(dtime, ios_base::app | ios_base::out);
    write_dat(dscdata, dtime);
    close_file();

}

int
Format1DSCStrategy::process_to_db(const DSCUMap &dscdata, string dtime[], int server_id, int node_id, pqxx::work& pg_db_trans) {

    return write_db(dscdata, dtime, server_id, node_id, pg_db_trans);

}

void
Format1DSCStrategy::write_dat(const DSCUMap &my_dscdata, string dtime[]){
    
    // Now store the new data in the file
    datafile_.filestream << dtime[1];
    
    DSCUMap::const_iterator it1=my_dscdata.begin();
    while ( it1 != my_dscdata.end() ) {
        if ( (*it1).second != 0 ) {
            datafile_.filestream << " " << (*it1).first.second << " " << (*it1).second;    
        }
        it1++;
    }

    datafile_.filestream << endl;

}

int
Format1DSCStrategy::process_dat_line(DSCUMap &counts, std::string time_strings[], std::string dat_line) {

    DSCKey tmp_key;
    tmp_key.first = "All";
    typedef boost::tokenizer<boost::char_separator<char> > t_tokenizer;
    boost::char_separator<char> sep(" ");
    
    if ( dat_line.length() == 0 ) {
        cerr << endl << "Found empty line in dat file - skipped" << endl;
        return 1;
    }
    t_tokenizer tok(dat_line, sep);

    // Read the time and the alternating keys and values
    int i=0;
    t_tokenizer::iterator field=tok.begin();
    // Read time from first field
    time_strings[1] = *field;
    if (! is_valid_time(time_strings[1]) ) return 1;
    field++;
    for(; field!=tok.end();++field){
        i++;
        if ( i%2 != 0 ) tmp_key.second = *field;
        if ( i%2 == 0 ) {
            int tmp_value;
            stringstream(*field) >> tmp_value;
            counts[tmp_key] = tmp_value;
        }
    }
    return 0;

}

int
Format1DSCStrategy::write_db(const DSCUMap &my_dscdata, string dtime[], int server_id, int node_id, pqxx::work& pg_db_trans){

    DSCUMap::const_iterator it1=my_dscdata.begin();
    stringstream sql;
    sql.clear();
    int plot_id = get_plot_id(plot_name_, pg_db_trans);
    sql.str("");    
    sql << "INSERT INTO dsc.\"data_" << server_name_ << "_" << plot_name_ << "_" << dtime[2] << "\" (server_id, node_id, plot_id, starttime, key1, key2, value) values"; 
    while ( 1 ) {
        if ( (*it1).second != 0 ) {
            sql << " (" << server_id << ", " << node_id << ", " << plot_id 
                << ", timestamptz 'epoch' + " << dtime[1] 
                <<  " * interval '1 second', '" << (*it1).first.second << "', 'NONE', " 
                << (*it1).second << ")";

            it1++;
            if (it1 == my_dscdata.end() ) {
                sql << ";";
                break;
            } else {
                sql << ",";
            }
        } else {
            cerr << "Format 1 Error: Bad data at " << plot_name_ << " " << dtime[1] << ". Skipping..." << endl;
            return 1;
        }
    }
    try {
        pg_db_trans.exec(sql.str());
    }
    catch ( pqxx::unique_violation & e )
    {
        cerr << "Format 1 unique_violation error: " << e.what() << endl;
        return 1;
    }
    catch( runtime_error & e )
    {
        cerr << "Format 1 runtime error: " << e.what() << endl;
        exit( EXIT_FAILURE );
    }
    catch( std::exception & e )
    {
        cerr << "Format 1 exception: " << e.what() << sql.str() << endl;
        exit( EXIT_FAILURE );
    }
    catch( ... )
    {
        cerr << "Format 1 Unknown exception caught" << endl;
        exit( EXIT_FAILURE );
    }
    return 0;
}
