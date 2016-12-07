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
#include <boost/algorithm/string.hpp>

#include "pqxx/pqxx"

#include "dsc_types.h"
#include "DSCStrategy.h"
#include "Format3aDSCStrategy.h"

//  Format3 has format k N(k)
//  it also contains data for all time not just 1 day

using namespace std;

Format3aDSCStrategy::Format3aDSCStrategy(string server, string name, string keys[], int keylength) : DSCStrategy(server, name, keys, keylength) {
    
}

void
Format3aDSCStrategy::preprocess_data(const DSCUMap &orig_dscdata, DSCUMap &new_dscdata, string /*dtime*/[], int /*server*/, int /*node*/, pqxx::work* /*pg_db_trans*/) {
	
    // Only called if the input channel was XML
    DSCKey tmp_key;
    tmp_key.first = "All";
    tmp_key.second = "All";
    new_dscdata[tmp_key] = accum1d_to_count(orig_dscdata);

}

void
Format3aDSCStrategy::process_to_dat(const DSCUMap &dscdata, string dtime[]) {
    
    open_file(dtime, ios_base::app | ios_base::out);
    write_dat(dscdata, dtime);
    close_file();

}

int
Format3aDSCStrategy::process_to_db(const DSCUMap &dscdata, string dtime[], int server_id, int node_id, pqxx::work& pg_db_trans) {

    return write_db(dscdata,dtime,server_id,node_id,pg_db_trans);

}

void
Format3aDSCStrategy::write_dat(const DSCUMap &dscdata, string dtime[]) {
    
    DSCUMap::const_iterator it = dscdata.begin();
    datafile_.filestream << dtime[1];
    datafile_.filestream << " " << (*it).second << endl;

}

int
Format3aDSCStrategy::process_dat_line(DSCUMap &counts, std::string time_strings[], std::string dat_line) {

    int tmp_value;
    DSCKey tmp_key;
    tmp_key.first = "All";
    vector<string> splitvec;
    vector<string>::iterator it;
    
    boost::split(splitvec, dat_line, boost::is_any_of(" "));
    if ( splitvec.size() != 2 ) {
        cerr << endl << "Found line containing: " << dat_line << " - skipped." << endl;
        return 1;
    }
    it = splitvec.begin();
    if(*it == "#MD5") return 1;
    tmp_key.second = (*it);
    time_strings[1] = (*it);
    if (! is_valid_time(time_strings[1]) ) return 1;
    it++;
    stringstream((*it)) >> tmp_value;
    
    counts[tmp_key] = tmp_value;
    splitvec.clear();
    return 0;

}

void
Format3aDSCStrategy::read_db(DSCUMap &old_dscdata, string dtime[],
                     int server_id, int node_id, pqxx::work& pg_db_trans) {

    DSCKey tmp_key;
    tmp_key.first = "All";
    int tmp_int = 0;
    string tmp_str;
    string key1 ("key1");
    string key2 ("key2");
    string value ("value");
    stringstream sql;
    int plot_id = get_plot_id(plot_name_, pg_db_trans);
    sql << "SELECT key1, value FROM dsc.format1_3 where starttime=to_timestamp('" << dtime[1] 
        << "') AND plot_id = '" << plot_id << "'" 
        << " AND node_id = '" << node_id << "'"
        << " AND server_id = '" << server_id << "';" << endl;

    try{

        const pqxx::result R = pg_db_trans.exec(sql.str());
        pqxx::result::const_iterator row;
        for (row = R.begin(); row != R.end(); ++row) {
            row[key1].to(tmp_str);
            row[value].to(tmp_int);
            tmp_key.second = tmp_str;
            old_dscdata[tmp_key] = tmp_int;
        }
    }
    catch( runtime_error & e )
    {
        cerr << "Format 3a runtime error: " << e.what() << endl;
        exit( EXIT_FAILURE );
    }
    catch( std::exception & e )
    {
        cerr << "Format 3a exception: " << e.what() << endl;
        exit( EXIT_FAILURE );
    }
    catch( ... )
    {
        cerr << "Format 3a Unknown exception caught" << endl;
        exit( EXIT_FAILURE );
    }
}

int
Format3aDSCStrategy::write_db(const DSCUMap &dscdata, string dtime[], int server_id, int node_id, pqxx::work& pg_db_trans) {

    stringstream sql;
    int plot_id = get_plot_id(plot_name_, pg_db_trans);
    DSCUMap::const_iterator it = dscdata.begin();    
    sql << "INSERT INTO dsc.\"data_" << server_name_ << "_" << plot_name_ << "_" << dtime[2]
        << "\" (server_id, node_id, plot_id, starttime, key1, key2, value) values ("
        << server_id << ", " << node_id << ", " << plot_id
        << ", timestamptz 'epoch' + " << dtime[1] <<  " * interval '1 second', '" 
        << dtime[1] << "', 'NONE', " << (*it).second << ");" << endl;
    try {
        (void)pg_db_trans.exec(sql.str());
    }
    
    catch ( pqxx::unique_violation & e )
    {
        cerr << "Format 3a unique_violation error: " << e.what() << endl;
        return 1;
    }   
    catch( runtime_error & e )
    {
        cerr << "Format 3a runtime error: " << e.what() << endl;
        exit( EXIT_FAILURE );
    }
    catch( std::exception & e )
    {
        cerr << "Format 3a exception: " << e.what() << endl;
        exit( EXIT_FAILURE );
    }
    catch( ... )
    {
        cerr << "Format 3a Unknown exception caught" << endl;
        exit( EXIT_FAILURE );
    }
    return 0;

}
