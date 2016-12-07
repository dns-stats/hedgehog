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

#define BOOST_FILESYSTEM_NO_DEPRECATED

#include <iostream>
#include <map>
#include <string>

#include <boost/filesystem.hpp>
#include <boost/filesystem/fstream.hpp>
#include <boost/tokenizer.hpp>

#include "dsc_types.h"
#include "DSCStrategy.h"
#include "Format2DSCStrategy.h"

#include "pqxx/pqxx"

using namespace std;
namespace bfs = boost::filesystem;

Format2DSCStrategy::Format2DSCStrategy(string server, string name, string keys[], int keylength) : DSCStrategy(server, name, keys, keylength) {
    
}

void
Format2DSCStrategy::preprocess_data(const DSCUMap &orig_dscdata, DSCUMap &new_dscdata, string /*dtime*/[], int /*server*/, int /*node*/, pqxx::work* /*pg_db_trans*/) {

      if ( plot_name_.compare("traffic_volume_queries") == 0 || 
                plot_name_.compare("traffic_volume_responses") == 0  ||
                plot_name_.compare("traffic_sizes_queries") == 0 ||
                plot_name_.compare("traffic_sizes_responses") == 0 ) {
        new_dscdata = orig_dscdata;
    } else if ( ! keys_.empty() ) {
        new_dscdata = orig_dscdata;
        elsify_unwanted_keys(new_dscdata);    
    } else {
        swap_dimensions(orig_dscdata, new_dscdata);
    }

}

void
Format2DSCStrategy::process_to_dat(const DSCUMap &dscdata, string dtime[]) {
    
    open_file(dtime, ios_base::app | ios_base::out);
    write_dat(dscdata, dtime);
    close_file();

}

int
Format2DSCStrategy::process_to_db(const DSCUMap &dscdata, string dtime[], int server_id, int node_id, pqxx::work& pg_db_trans) {

     return write_db(dscdata, dtime, server_id, node_id, pg_db_trans);

}

void
Format2DSCStrategy::write_dat(const DSCUMap &my_dscdata, string dtime[]) {
    
    DSCUMap::const_iterator it;
    map<string,string> tmp_kv;
    map<string,string>::iterator does_key_exist;
    // Don't forget the map's key is a pair as well
    for ( it=my_dscdata.begin() ; it != my_dscdata.end(); it++ ){
        string t = static_cast<ostringstream*>( &(ostringstream() << (*it).second) )->str();
        does_key_exist = tmp_kv.find((*it).first.first); 
        if ( does_key_exist == tmp_kv.end() ) {
            tmp_kv[(*it).first.first] +=  (*it).first.second + ":" + t;
        } else {
            tmp_kv[(*it).first.first] +=  ":" + (*it).first.second + ":" + t;
        }
    }
    if (! tmp_kv.empty() ){
        datafile_.filestream << dtime[1];
        map<string,string>::iterator it1;
        for ( it1=tmp_kv.begin() ; it1 != tmp_kv.end(); it1++ ){
            datafile_.filestream << " " << (*it1).first << " " << (*it1).second;
        }
        datafile_.filestream << endl;
    }

}

int
Format2DSCStrategy::process_dat_line(DSCUMap &counts, std::string time_strings[], std::string dat_line) {

    // reads a 2-level hash database WITH time dimension
    // ie: time k1 (k:v:k:v) k2 (k:v:k:v)
    // each line comes from a single XML array
    // Need to return time and DSCUMap for each line
    
    string k;
    DSCKey tmp_key;
    typedef boost::tokenizer<boost::char_separator<char> > t_tokenizer;
    boost::char_separator<char> sep(" ");
    boost::char_separator<char> sep1(":");

    if ( dat_line.length() == 0 )  {
        cerr << endl << "Found empty line in dat file - skipped" << endl;
        return 1;
    }

    t_tokenizer tok(dat_line, sep);
    t_tokenizer::iterator field=tok.begin();
    time_strings[1] = *field;
    if (! is_valid_time(time_strings[1]) ) return 1;
    field++;
    int i=0;
    for(; field!=tok.end();++field) {
        i++;
        if ( i%2 != 0 ) {
            tmp_key.first = *field;
            continue;
        }
        
        t_tokenizer tok1(*field, sep1);
        int j=0;
        for(t_tokenizer::iterator field1=tok1.begin(); field1 != tok1.end();++field1) {
            j++;
            if ( j%2 != 0 ) {
                tmp_key.second = *field1;
                continue;
            }

            int tmp_value;
            stringstream(*field1) >> tmp_value;
            counts[tmp_key] = tmp_value;
        }
    }
    return 0;

}

int
Format2DSCStrategy::write_db(const DSCUMap &my_dscdata, string dtime[], int server_id, int node_id, pqxx::work& pg_db_trans) {

    DSCUMap::const_iterator it1=my_dscdata.begin();
    stringstream sql;
    sql.clear();
    int plot_id = get_plot_id(plot_name_, pg_db_trans);
    sql.str("");

    sql << "INSERT INTO dsc.\"data_" << server_name_ << "_" << plot_name_ << "_" << dtime[2] << "\" (server_id, node_id, plot_id, starttime, key1, key2, value) values";

    if (my_dscdata.empty()) {
      cerr << "Format 2 Error: Empty data set for " << plot_name_ << " " << dtime[1] << ". Skipping..." << endl;
      return 1;
    }

    while ( 1 ) {
        if ( (*it1).second != 0 ) {
            sql << " (" << server_id << ", " << node_id << ", " << plot_id
                << ", timestamptz 'epoch' + " << dtime[1] <<  " * interval '1 second', '"
                << (*it1).first.first << "','" << (*it1).first.second << "', " << (*it1).second << ")";

            it1++;
            if (it1 == my_dscdata.end() ) {
                sql << ";";
                break;
            } else {
                sql << ",";
            }
        } else {
            cerr << "Format 2 Error: Bad data at " << plot_name_ << " " << dtime[1] << ". Skipping..." << endl;
            return 1;
        }
    }

    try {
        pg_db_trans.exec(sql.str());
    }
    catch ( pqxx::unique_violation & e )
    {
        cerr << "Format 2 unique_violation error: " << e.what() << endl;
        return 1;
    } 
    catch( runtime_error & e )
    {
        cerr << "Format 2 runtime error: " << e.what() << endl;
        exit( EXIT_FAILURE );
    }
    catch( std::exception & e )
    {
        cerr << "Format 2 exception: " << e.what() << endl;
        exit( EXIT_FAILURE );
    }
    catch( ... )
    {
        cerr << "Format 2 Unknown exception caught" << endl;
        exit( EXIT_FAILURE );
    }
    return 0;

}