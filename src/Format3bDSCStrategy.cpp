/* 
 * Copyright 2014, 2015, 2016 Internet Corporation for Assigned Names and Numbers.
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
#include "Format3bDSCStrategy.h"

// Format3b has format k N(k)

using namespace std;

Format3bDSCStrategy::Format3bDSCStrategy(string server, string name, string keys[], int keylength) : DSCStrategy(server, name, keys, keylength) {
    
}

void
Format3bDSCStrategy::preprocess_data(const DSCUMap &orig_dscdata, DSCUMap &new_dscdata, string dtime[], int /*server_id*/, int /*node_id*/, pqxx::work* pg_db_trans) {
    
    if (pg_db_trans == NULL) {
        open_file(dtime, ios_base::in);
        read_dat(new_dscdata);
        merge_accum1d(orig_dscdata,new_dscdata);
        close_file();
    }
    else {
        new_dscdata = orig_dscdata;
    }

}

void
Format3bDSCStrategy::process_to_dat(const DSCUMap &dscdata, string dtime[]) {

    // reopen dat file with trunc to write out merged data
    open_file(dtime, ios_base::trunc | ios_base::out);
    write_dat(dscdata,dtime);
    close_file();

}

int
Format3bDSCStrategy::process_to_db(const DSCUMap &dscdata, string dtime[], int server_id, int node_id, pqxx::work& pg_db_trans) {

    return write_db(dscdata,dtime,server_id,node_id,pg_db_trans);

}

void
Format3bDSCStrategy::write_dat(const DSCUMap &old_dscdata, string /*dtime*/[]) {

    DSCUMap::const_iterator it = old_dscdata.begin();
    for ( ; it != old_dscdata.end() ; it++) {
        datafile_.filestream << (*it).first.second << " " << (*it).second << endl;
    }

}

void
Format3bDSCStrategy::read_dat(DSCUMap &old_dscdata) {

    int tmp_value;
    DSCKey tmp_key;
    tmp_key.first = "All";
    string line;
    vector<string> splitvec;
    vector<string>::iterator it;
    while (getline(datafile_.filestream,line)) {
        boost::split(splitvec, line, boost::is_any_of(" "));
        if ( splitvec.size() != 2 ) {
            cerr << "Bad data skipped." << endl;
            continue;
        }
        it = splitvec.begin();
        tmp_key.second = (*it);
        if (tmp_key.second == "#MD5") continue;
        it++;
        stringstream((*it)) >> tmp_value;
        old_dscdata[tmp_key] = tmp_value;
        splitvec.clear();
    }

}

void
Format3bDSCStrategy::process_dat_file(DSCUMap &counts, std::string time_strings[], const boost::filesystem::path &/*file_path*/) {

    open_file(time_strings, ios_base::in);
    read_dat(counts);
    close_file();

}

int
Format3bDSCStrategy::write_db(const DSCUMap &old_dscdata, string dtime[], int server_id, int node_id, pqxx::work& pg_db_trans) {

    DSCUMap::const_iterator it1 = old_dscdata.begin();
    stringstream sql;
    stringstream tablename;
    sql.clear();
    int plot_id = get_plot_id(plot_name_, pg_db_trans);
    sql.str("");
    tablename << "dsc.\"data_" << server_name_ << "_" << plot_name_ << "_" << dtime[2] << "\"";

    for ( ; it1 != old_dscdata.end() ; it1++ ) {    
        sql.clear();
        sql.str("");
        sql << "with upsert as ( update " << tablename.str() << " as d "
                << " set value= " << (*it1).second << " + e.value "
                << " from " << tablename.str() << " as e "
                << " where d.starttime=e.starttime and d.server_id=e.server_id and d.node_id=e.node_id and d.plot_id=e.plot_id and d.key1=e.key1 and d.key2=e.key2 "
                << " and e.server_id= " << server_id
                << " and e.node_id= " << node_id 
                << " and e.plot_id= " << plot_id 
                << " and e.starttime= " << "to_timestamp('" << dtime[0]  << "', 'YYYYMMDD')"
                << " and e.key1= '" << (*it1).first.first << "'"
                << " and e.key2= '" << (*it1).first.second  << "'"
                << " returning d.* )"
                << " insert into " << tablename.str()
                << " (server_id, node_id, plot_id, starttime, key1, key2, value) "
                << " select " << server_id << " , " << node_id << " , " << plot_id << " , " << "to_timestamp('" << dtime[0]  << "', 'YYYYMMDD')" << " , '" << (*it1).first.first << "', '"  << (*it1).first.second << "', " << (*it1).second
                << " where not exists (select 1 from upsert);";
        try {       
            pg_db_trans.exec(sql.str());
        }
        catch ( pqxx::unique_violation & e )
        {
            cerr << "Format 3b unique_violation error: " << e.what() << endl;
            return 1;
        }   
        catch( runtime_error & e )
        {
            cerr << "Format 3b write_db runtime error: " << e.what() << endl;
            exit( EXIT_FAILURE );
        }
        catch( std::exception & e )
        {
            cerr << "Format 3b write_db exception: " << e.what() << endl;
            exit( EXIT_FAILURE );
        }
        catch( ... )
        {
            cerr << "Format 3b write_db Unknown exception caught" << endl;
            exit( EXIT_FAILURE );
        }
    }
    return 0;

}
