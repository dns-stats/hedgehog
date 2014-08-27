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

/**
 */

#define BOOST_FILESYSTEM_NO_DEPRECATED

#include <string>
#include <map>
#include <exception>
#include <iostream>
#include <time.h>

#include <boost/property_tree/ptree.hpp>
#include <boost/property_tree/xml_parser.hpp>
#include <boost/foreach.hpp>
#include <boost/algorithm/string.hpp>
#include <boost/filesystem.hpp>

#include "pqxx/pqxx"

#include "dsc_types.h"
#include "DSCDataManager.h"
#include "DSCStrategy.h"
#include "DSCStrategyFactory.h"

#include "Format1DSCStrategy.h"
#include "Format2DSCStrategy.h"
#include "Format3aDSCStrategy.h"
#include "Format3bDSCStrategy.h"
#include "Format4DSCStrategy.h"

using namespace std;

DSCDataManager::DSCDataManager(const string& server, const string& node, pqxx::work *pg_db_trans) {

    // Use the transaction pointer to decide if the output will be a database
    if ( pg_db_trans == NULL ) {
        using_pg_db_ = false;
        pg_db_transaction_ = NULL;
        server_ = server;
        node_ = node;
    } else {
        using_pg_db_ = true;
        pg_db_transaction_ = pg_db_trans;
        server_ = server;
        node_ = node;
        server_id_ = get_server_id(server, *pg_db_trans);
        node_id_ = get_node_id(server_id_, node, *pg_db_trans);
    }

}

void
DSCDataManager::clear() {

    start_time_ = 0;
    name_.clear();
    time_strings_[0].clear();
    time_strings_[1].clear();
    time_strings_[2].clear();
    counts_.clear();
    preprocess_required_ = false;
    for(vector<DSCStrategy*>::iterator strategy_it = strategies_.begin(); strategy_it != strategies_.end(); ++strategy_it){
        delete *strategy_it;
    }
    strategies_.clear();

}

int
DSCDataManager::load(const string dat_line, vector<DSCStrategy*>::iterator strategy_it) {

    clear();
    
    //node_ = bfs::initial_path().filename().generic_string();
    //server_ = bfs::initial_path().parent_path().filename().generic_string();
    //name_ = file_path.filename().string();
    
    // Call out to the strategy factory as the strategies 
    // know how to convert the line of data to a DSCUMap
    if ( using_pg_db_ == true ){
        if ( (*strategy_it)->process_dat_line(counts_, time_strings_, dat_line) != 0 ) return 1;
        struct tm *tmp_time;
        time_t tmp_time1;
        tmp_time1 = (time_t)atoi(time_strings_[1].c_str());
        tmp_time = gmtime(const_cast<const time_t *>(&tmp_time1));
        char yyyymmdd_c[9];
        char yyyy_mm_c[8];
        strftime(yyyymmdd_c, 9, "%Y%m%d", tmp_time);
        time_strings_[0].assign(yyyymmdd_c,8);
        strftime(yyyy_mm_c, 8, "%Y_%m", tmp_time);
        time_strings_[2].assign(yyyy_mm_c,7);
    } else {
        cerr << "Error: Attempt to write a dat file to a dat file for graph " << name_ << endl;
        exit(1);
    }
    return 0;
    
}

int
DSCDataManager::load(const boost::filesystem::path& file_path, vector<DSCStrategy*>::iterator strategy_it) {

    clear();

    name_ = file_path.filename().string();
    
    struct tm tm;
    std::stringstream ss;
    string tmp_time_string;
    char yyyy_mm_c[8];

    //  The only time/date we know of is that contained in the path 
    //  to the dat file.
    time_strings_[0].assign(file_path.parent_path().filename().string());
    tmp_time_string = time_strings_[0] + " 00:00:00";
    if ( strptime(tmp_time_string.c_str(), "%Y%m%d %H:%M:%S", &tm) != NULL ) {
        ss << mktime(&tm);
        time_strings_[1] = ss.str();
    strftime(yyyy_mm_c, 8, "%Y_%m", &tm);
    time_strings_[2].assign(yyyy_mm_c,7);

    } else {
        cerr << "Error: Unable to extract unixtime when loading dat file " << file_path.string() << endl;
        return 1;
    }

    // Call out to the strategy factory as the strategies 
    // know how to convert the file to a DSCUMap
    if ( using_pg_db_ == true ){
        (*strategy_it)->process_dat_file(counts_, time_strings_, file_path);
    } else {
        cerr << "Error: Attempt to write a dat file to a dat file for graph " << name_ << endl;
        exit(1);
    }
    return 0;

}

int 
DSCDataManager::load(const boost::property_tree::ptree::value_type &array_value, bool rssac) {

    int dim_counter = 0; 
    string dim_type[2];
    string dim1_value;
    string dim2_value;

    dim_type[0].clear();
    dim_type[1].clear();
    dim1_value.clear();
    dim2_value.clear();
    
    clear();
    preprocess_required_ = true;

    // catch any generic XML processing errors
    try {
	    if ( boost::equals ( array_value.first, "array") ) {
	        BOOST_FOREACH(boost::property_tree::ptree::value_type const& value, array_value.second) {
	            // Get attributes from the array element
	            if ( boost::equals ( value.first, "<xmlattr>") ) {
	                name_       = value.second.get<string>("name");
	                start_time_ = value.second.get<int>("start_time");

	                // round start time down to start of the minute
	                start_time_ = int(start_time_ / 60) * 60;

	                struct tm *tmp_time;
	                time_t tmp_time1;
	                tmp_time1 = (time_t)start_time_;
	                tmp_time = gmtime(const_cast<const time_t *>(&tmp_time1));
	                char yyyymmdd_c[9];
	                char yyyy_mm_c[8];
	                strftime(yyyymmdd_c, 9, "%Y%m%d", tmp_time);
	                time_strings_[0].assign(yyyymmdd_c,8);
	                // don't use strftime here due to timezone issues
	                ostringstream tmp_time2;
	                tmp_time2 << start_time_;
	                time_strings_[1] = tmp_time2.str();
	                strftime(yyyy_mm_c, 8, "%Y_%m", tmp_time);
	                time_strings_[2].assign(yyyy_mm_c,7);
	            }

	            // Get dimensions (Should always be 2 of them)
	            if ( boost::equals ( value.first, "dimension") ) {
	                BOOST_FOREACH(boost::property_tree::ptree::value_type const& dim_value, value.second) {
	                    if ( boost::equals ( dim_value.first, "<xmlattr>") ) {
	                        dim_type[dim_counter] = dim_value.second.get<string>("type");
	                        dim_counter++;
	                    }
	                }
	            }

	            // Get data
	            if ( boost::equals ( value.first, "data") ) {
	                BOOST_FOREACH(boost::property_tree::ptree::value_type const& value1, value.second) {
	                    if ( boost::equals ( value1.first, dim_type[0]) ) {
	                        BOOST_FOREACH(boost::property_tree::ptree::value_type const& value2, value1.second) {
	                            if ( boost::equals ( value2.first, "<xmlattr>") ) {
	                                dim1_value = value2.second.get<string>("val");
	                            } else if ( boost::equals ( value2.first, dim_type[1]) ) {
	                                int tmp_count = 0;
	                                BOOST_FOREACH(boost::property_tree::ptree::value_type const& value3, value2.second) {
	                                    if ( boost::equals ( value3.first, "<xmlattr>") ) {
	                                        dim2_value = value3.second.get<string>("val");
	                                        tmp_count  = value3.second.get<int>("count");
	                                    }
	                                }
	                                DSCKey tmp_key(dim1_value,dim2_value);
	                                counts_.insert(pair<DSCKey,int>(tmp_key, tmp_count));
	                            }
	                        }
	                    }
	                }
	            }
	        }
	    }
	}
    catch( std::exception & e )
    {
        cerr << "Exception loading XML file: " << e.what() << endl;
        return 1;
    }
    catch( ... )
    {
        cerr << "Unknown exception caught" << endl;
        return 1;
    }

  strategies_ = DSCStrategyFactory::createStrategy(server_, name_, rssac);
  return 0;

}

int
DSCDataManager::process() {

    int status = 0;

    // if no data, don't process
    if(counts_.size() == 0)
        return 0;
    
    long unsigned int i=0;
    vector<DSCStrategy*>::iterator strategy_it;
    
    for(strategy_it = strategies_.begin(); strategy_it != strategies_.end(); strategy_it++){
        DSCUMap *output_counts = &counts_;
        DSCUMap new_counts;
        // preprocess is only required if the input channel was XML
        if (preprocess_required_) {
           (*strategy_it)->preprocess_data(counts_, new_counts, time_strings_, server_id_, node_id_, pg_db_transaction_);
           output_counts = &new_counts;
        }
        if ( using_pg_db_ == true ) {
            status = (*strategy_it)->process_to_db(*output_counts, time_strings_, server_id_, node_id_, *pg_db_transaction_);
            if (status) return 1;
        }
        if ( using_pg_db_ == false ) {
            (*strategy_it)->process_to_dat(*output_counts, time_strings_);
        }
        i++;
    }
    return 0;

}

int
DSCDataManager::process(vector<DSCStrategy*>::iterator strategy_it) {

    int status=0;
    // if no data, don't process
    if(counts_.size() == 0)
        return 0;

    DSCUMap *output_counts = &counts_;
    DSCUMap new_counts;
    if (preprocess_required_){
       (*strategy_it)->preprocess_data(counts_, new_counts, time_strings_, server_id_, node_id_, pg_db_transaction_);
       output_counts = &new_counts;
    }
    if ( using_pg_db_ == true ) {
        status = (*strategy_it)->process_to_db(*output_counts, time_strings_, server_id_, node_id_, *pg_db_transaction_);
        if (status) return 1;
    } else {
        cerr << "Error: Expected to use a database but no transaction found." << endl;
        exit(1);
    }
    return 0;

}

int
DSCDataManager::get_server_id(const string& server, pqxx::work& pg_db_trans) {

    stringstream sql;
    try {
        sql.clear();
        sql.str("");
        sql << "SELECT id FROM dsc.server WHERE name = '" << server << "'" << endl;
        pqxx::result r = pg_db_trans.exec(sql.str());
        if ( r.size() != 1 ) {
            cerr << "Error: Expected 1 server with name " << server << ", "
                 << "but found " << r.size() << endl;
            exit( EXIT_FAILURE );
        }
        return r[0][0].as<int>();
    }
    catch( runtime_error & e )
    {
        cerr << "Runtime error: " << e.what() << endl;
        exit( EXIT_FAILURE );
    }
    catch( std::exception & e )
    {
        cerr << "Exception: " << e.what() << sql.str() << endl;
        exit( EXIT_FAILURE );
    }
    catch( ... )
    {
        cerr << "Unknown exception caught" << endl;
        exit( EXIT_FAILURE );
    }

}

int
DSCDataManager::get_node_id(int server_id, const string& node, pqxx::work& pg_db_trans) {

    stringstream sql;
    try {
        sql.clear();
        sql.str("");
        sql << "SELECT id FROM dsc.node WHERE name = '" << node << "' AND server_id = '" << server_id << "'" << endl;
        pqxx::result r = pg_db_trans.exec(sql.str());
        if ( r.size() != 1 ) {
            cerr << "Error: Expected 1 node with name " << node << " and server ID " << server_id << ", "
                 << "but found " << r.size() << endl;
            exit( EXIT_FAILURE );
        }
        return r[0][0].as<int>();
    }
    catch( runtime_error & e )
    {
        cerr << "Runtime error: " << e.what() << endl;
        exit( EXIT_FAILURE );
    }
    catch( std::exception & e )
    {
        cerr << "Exception: " << e.what() << sql.str() << endl;
        exit( EXIT_FAILURE );
    }
    catch( ... )
    {
        cerr << "Unknown exception caught" << endl;
        exit( EXIT_FAILURE );
    }

}
