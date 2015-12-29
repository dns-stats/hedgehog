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

#include <iostream>
#include <map>
#include <string>
#include <vector>

#define BOOST_FILESYSTEM_NO_DEPRECATED
#include <boost/filesystem.hpp>
#include <boost/filesystem/fstream.hpp>
#include <boost/algorithm/string.hpp>
#include <boost/foreach.hpp>

#include "dsc_types.h"
#include "DSCStrategy.h"
#include "Format4DSCStrategy.h"

#include "pqxx/pqxx"

// Format4 has format j k N(j,k)

using namespace std;
namespace bfs = boost::filesystem;

Format4DSCStrategy::Format4DSCStrategy(string server, string name, string keys[], int keylength) : DSCStrategy(server, name, keys, keylength) {

}

void
Format4DSCStrategy::preprocess_data(const DSCUMap &orig_dscdata, DSCUMap &new_dscdata, string dtime[], int /*server_id*/, int /*node_id*/, pqxx::work* pg_db_trans) {

    DSCUMap tmp_dscdata;

    // Call the munger
    // It depends on m_name - the if may be better in the factory.
    if ( plot_name_ == "client_subnet2_accum" || plot_name_ == "qtype_vs_tld" || plot_name_ == "client_addr_vs_rcode_accum") {
        swap_dimensions(orig_dscdata, tmp_dscdata);
    } else if ( plot_name_ == "dns_ip_version_vs_qtype" ) {
        tmp_dscdata = orig_dscdata;
        elsify_unwanted_keys(tmp_dscdata);  
    } else {
        tmp_dscdata = orig_dscdata;
    }
    
    // If we are writing to a dat file then we need to merge data
    // If we are writing to the database then we will use a CTE upsert
    if (pg_db_trans == NULL) {
        open_file(dtime, ios_base::in);   
        // Read the old dat file in as we need to merge old and new data
        read_dat(new_dscdata);   
        close_file();
        merge_accum2d(tmp_dscdata, new_dscdata);
        // Trimmer: runs once per hour of xml data
        if ( plot_name_ == "client_subnet2_accum" || plot_name_ == "qtype_vs_tld" || plot_name_ == "client_subnet_vs_tld") {
                int tmp_value;
                stringstream(dtime[1]) >> tmp_value;
                if ((59*60) == (tmp_value % 3600)) {
                        trim_accum2d(new_dscdata);
                }
        } 
    }  else {
        new_dscdata = tmp_dscdata;
    }
    
}

void
Format4DSCStrategy::process_dat_file(DSCUMap &counts, std::string time_strings[], const boost::filesystem::path &/*file_path*/) {

    open_file(time_strings, ios_base::in);
    read_dat(counts);
    close_file();

}

void
Format4DSCStrategy::process_to_dat(const DSCUMap &dscdata, string dtime[]) {

    open_file(dtime, ios_base::trunc | ios_base::out);
    write_dat(dscdata,dtime);
    close_file();

}

int
Format4DSCStrategy::process_to_db(const DSCUMap &dscdata, string dtime[], int server_id, int node_id, pqxx::work& pg_db_trans) {

    return write_db(dscdata,dtime, server_id, node_id, pg_db_trans);

}

void
Format4DSCStrategy::write_dat(const DSCUMap &old_dscdata, string /*dtime*/[]){

    DSCUMap::const_iterator it1=old_dscdata.begin();
    for ( ; it1 != old_dscdata.end() ; it1++ ) {
        datafile_.filestream << (*it1).first.first << " " << (*it1).first.second << " " << (*it1).second << endl;
    }

}

void
Format4DSCStrategy::read_dat(DSCUMap &old_dscdata) {

    string token;
    int tmp_value;
    DSCKey tmp_key;
    string line;
    vector<string> splitvec;
    vector<string>::iterator it;
    while (getline(datafile_.filestream,line)) {
        
        stringstream lineStream(line);
        
        lineStream >> tmp_key.first;
        if (tmp_key.first == "#MD5") continue;
        lineStream >> tmp_key.second;
        lineStream >> tmp_value;
        if (! lineStream.eof()) {
            cerr << "Bad data reading" << plot_name_ << "dat file" << endl;
            continue;
        }
        old_dscdata[tmp_key] = tmp_value;
    }

}

int
Format4DSCStrategy::write_db(const DSCUMap &old_dscdata, string dtime[], int server_id, int node_id, pqxx::work& pg_db_trans){

    stringstream sql;
    stringstream tablename;
    DSCUMap::const_iterator it1=old_dscdata.begin();
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
        catch ( pqxx::unique_violation & e ) {
            cerr << "Format 4 unique_violation error: " << e.what() << endl;
            return 1;
        }
        catch( runtime_error & e )
        {
            cerr << "Format 4 write_db Runtime error: " << e.what() << endl;
            exit( EXIT_FAILURE );
        }
        catch( std::exception & e )
        {
            cerr << "Format 4 write_db exception: " << e.what() << endl;
            exit( EXIT_FAILURE );
        }
        catch( ... )
        {
            cerr << "Format 4 write_db Unknown exception caught" << endl;
            exit( EXIT_FAILURE );
        }
    }
    
    // Trimmer: runs once per hour of xml data
    int debug = 0;
    int tmp_value;
    stringstream(dtime[1]) >> tmp_value;
    if ((59*60) == (tmp_value % 3600)) {
        if ( debug == 1 ) cout << "Trimmer Started." << endl;
        if ( plot_name_ == "client_subnet2_accum" || plot_name_ == "qtype_vs_tld" || plot_name_ == "client_subnet_vs_tld") {
            if ( debug == 1 ) cout << "Trimmer found plot " << plot_name_ << endl;
            
            
            // first create a string to hold all the common query parameters
            stringstream sql_query_params;
            sql_query_params << " and server_id= " << server_id
                             << " and node_id= " << node_id 
                             << " and plot_id= " << plot_id 
                             << " and starttime= " << "to_timestamp('" << dtime[0]  << "', 'YYYYMMDD') ";
            stringstream sql_ignore_skipped;
            sql_ignore_skipped << " key1 NOT IN ('-:SKIPPED_SUM:-', '-:SKIPPED:-') ";
                  
            // Now figure out all the key2s which need trimming and loop over them
            string key2totrim;
            string key2 ("key2");
            sql.clear();
            sql.str("");
            sql << "select key2 from (select key2, count(*) from " << tablename.str()
                << " where " << sql_ignore_skipped.str() << sql_query_params.str()
                << " group by key2) as to_trim where count > 1000;";
            if ( debug == 1 ) cout << "Trimmer executed: " << sql.str() << endl << endl;
            try {
                 const pqxx::result R = pg_db_trans.exec(sql.str());
                 if ( debug == 1 ) cout << "Trimmer got back " << R.size() << " rows." << endl << endl;
                 pqxx::result::const_iterator row;
                 for (row = R.begin(); row != R.end(); ++row) {
                     row[key2].to(key2totrim);
                     stringstream sql1, sql2, sql3, sql4, sql5, sql6;
                     string skipped_str ("skipped");
                     string skipped_sum_str ("skipped_sum");                 
                     int skipped = 0;
                     int skipped_sum = 0;
                     int skipped_new = 0;
                     int skipped_sum_new = 0;
                                                          
                     // Calculate the new values - i.e. row count above 1000    
                     sql1 << "select sum(value) as skipped_sum, count(value) as skipped"
                          << " from "
                                << " (select key1, value from " << tablename.str()
                                << " where key2= '" << key2totrim << "' "
                                << " and " << sql_ignore_skipped.str() << sql_query_params.str() 
                                << " order by value desc offset 1000) as rowstotrim;";
                     if ( debug == 1 ) cout << "Trimmer executed: " << sql1.str() << endl << endl;
                     const pqxx::result R1 = pg_db_trans.exec(sql1.str());
                     if ( debug == 1 ) cout << "Trimmer got back " << R1.size() << " rows." << endl << endl;
                     pqxx::result::const_iterator row1;
                     for (row1 = R1.begin(); row1 != R1.end(); ++row1) {
                         row1[skipped_str].to(skipped_new);
                         row1[skipped_sum_str].to(skipped_sum_new);
                     }
                     if ( debug == 1 ) cout << "Trimmer skipped_new = " << skipped_new << ", skipped_sum_new = " << skipped_sum_new << endl << endl;
                     
                     // Pull the existing values out of the database for skipped and skipped sum
                     // and update or insert the new ones
                     sql2 << "select value as skipped_sum from " << tablename.str() 
                          << " where key2= '" << key2totrim 
                          << "' and key1='-:SKIPPED_SUM:-'"
                          << sql_query_params.str() << ";";
                     if ( debug == 1 ) cout << "Trimmer executed: " << sql2.str() << endl << endl;
                     const pqxx::result R2 = pg_db_trans.exec(sql2.str());
                     if ( debug == 1 ) cout << "Trimmer got back " << R2.size() << " rows." << endl << endl;
                     if (R2.size() > 1 ) {
                        cerr << "Format 4 write_db Expected 0 or 1 skipped_sum records. Found " << R2.size() << endl;
                        exit( EXIT_FAILURE );                     
                     }                    
                     if (R2.size() == 1) {
                         R2.begin()[skipped_sum_str].to(skipped_sum);
                         if ( debug == 1 ) cout << "Trimmer skipped_sum existing= " << skipped_sum << endl << endl;
                         skipped_sum = skipped_sum + skipped_sum_new;
                         if ( debug == 1 ) cout << "Trimmer skipped_sum updated= " << skipped_sum << endl << endl;
                         // Now update them in the database
                         sql4 << "update " << tablename.str()
                              << " set value = " << skipped_sum 
                              << " where key2='" << key2totrim << "' "
                              << " and key1='-:SKIPPED_SUM:-'"
                              << sql_query_params.str() << ";";
                         if ( debug == 1 ) cout << "Trimmer executed: " << sql4.str() << endl << endl;
                     }
                     else {
                        sql4 << " insert into " << tablename.str()
                             << " (server_id, node_id, plot_id, starttime, key1, key2, value) "
                             << " values (" << server_id << " , " 
                             << node_id << " , " 
                             << plot_id << " , " 
                             << "to_timestamp('" << dtime[0]  << "', 'YYYYMMDD') " 
                             << ", '-:SKIPPED_SUM:-', '"  
                             << key2totrim << "', " 
                             << skipped_sum_new << ");";  
                        if ( debug == 1 ) cout << "Trimmer executed: " << sql4.str() << endl << endl;
                     }
                     const pqxx::result R10 = pg_db_trans.exec(sql4.str());
                     if ( debug == 1 ) cout << "Trimmer affected " << R10.affected_rows() << " rows." << endl << endl;
                     sql3 << "select value as skipped from " << tablename.str() 
                          << " where key2= '" << key2totrim 
                          << "' and key1='-:SKIPPED:-'"
                          << sql_query_params.str() << ";";
                     if ( debug == 1 ) cout << "Trimmer executed: " << sql3.str() << endl << endl;
                     const pqxx::result R3 = pg_db_trans.exec(sql3.str());
                     if ( debug == 1 ) cout << "Trimmer got back " << R3.size() << " rows." << endl << endl;
                     pqxx::result::const_iterator row3;
                     if (R3.size() > 1 ) {
                        cerr << "Format 4 write_db Expected 0 or 1 skipped records. Found " << R3.size() << endl;
                        exit( EXIT_FAILURE );                     
                     }                    
                     if (R3.size() == 1) {
                         R3.begin()[skipped_str].to(skipped);
                         if ( debug == 1 ) cout << "Trimmer skipped existing = " << skipped << endl << endl;
                         skipped = skipped + skipped_new;
                         if ( debug == 1 ) cout << "Trimmer skipped updated= " << skipped << endl << endl;
                         sql5 << "update " << tablename.str()
                              << " set value = " << skipped 
                              << " where key2='" << key2totrim << "' "
                              << " and key1='-:SKIPPED:-'"
                              << sql_query_params.str() << ";";
                         if ( debug == 1 ) cout << "Trimmer executed: " << sql5.str() << endl << endl;
                     }
                     else {
                         sql5 << " insert into " << tablename.str()
                             << " (server_id, node_id, plot_id, starttime, key1, key2, value) "
                             << " values (" << server_id << " , " 
                             << node_id << " , " 
                             << plot_id << " , " 
                             << "to_timestamp('" << dtime[0]  << "', 'YYYYMMDD') " 
                             << ", '-:SKIPPED:-', '"  
                             << key2totrim << "', " 
                             << skipped_new << ");";             
                         if ( debug == 1 ) cout << "Trimmer executed: " << sql5.str() << endl << endl;
                     }                           
                     const pqxx::result R11 = pg_db_trans.exec(sql5.str());
                     if ( debug == 1 ) cout << "Trimmer affected " << R11.affected_rows() << " rows." << endl << endl;

                     // Now we need to delete all the skipped keys
                     sql6 << "delete from " << tablename.str() 
                          << "where key2='" << key2totrim << "' "
                          << sql_query_params.str()
                          << " and key1 in "
                                << " (select key1 from " << tablename.str()
                                << " where key2= '" << key2totrim << "' "
                                << " and  " << sql_ignore_skipped.str() << sql_query_params.str() 
                                << " order by value desc offset 1000);";
                     if ( debug == 1 ) cout << "Trimmer executed: " << sql6.str() << endl << endl;
                     
                     const pqxx::result R12 = pg_db_trans.exec(sql6.str());
                     if ( debug == 1 ) cout << "Trimmer affected " << R12.affected_rows() << " rows." << endl << endl;
                }                  
            }
            catch ( pqxx::unique_violation & e ) {
                cerr << "Format 4 unique_violation error: " << e.what() << endl;
                return 1;
            }
            catch( runtime_error & e )
            {
                cerr << "Format 4 write_db Runtime error: " << e.what() << endl;
                exit( EXIT_FAILURE );
            }
            catch( std::exception & e )
            {
                cerr << "Format 4 write_db exception: " << e.what() << endl;
                exit( EXIT_FAILURE );
            }
            catch( ... )
            {
                cerr << "Format 4 write_db Unknown exception caught" << endl;
                exit( EXIT_FAILURE );
            }
        } 
    }
    return 0;

}