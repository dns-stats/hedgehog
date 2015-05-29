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

#include <string>
#include <map>
#include <time.h>

#include <boost/property_tree/ptree.hpp>
#include <boost/unordered_map.hpp>

#include "pqxx/pqxx"

#include "dsc_types.h"

using namespace std;

class DSCStrategy;


/// \brief Class that parses the DSC data and calls an appropriate strategy to 
/// to deal with the data.
/// 
/// This class is responsible for owning the data and providing load functions 
/// for the various input channels and provides functions to process the data 
/// using an appropriate strategy.
class DSCDataManager
{
    
private:
    
    // ****************
    // Member data
    // ****************
    /// \brief string to hold the name of the array
    std::string name_;

    /// \brief integer start time read from the xml
    int start_time_;

    /// \brief array of strings to hold time is a variety of formats
    std::string time_strings_[3];
    /// \brief unordered map (defined in dsc_types.h) containing the data
    /// loaded from the xml
    DSCUMap counts_;
    /// \brief A vetor holding the strategies returned by the factory
    std::vector<DSCStrategy*> strategies_;
    /// \brief Boolean to tell if the output is a database or a dat file
    bool using_pg_db_;
    /// \brief Pointer to a PostgreSQL transaction.
    pqxx::work *pg_db_transaction_;
    /// \brief The name of the server node.
    std::string node_;
    /// \brief The name of the server.
    std::string server_;
    
    int node_id_;
    int server_id_;
    bool preprocess_required_;
    int get_server_id(const string& server, pqxx::work& pg_db_trans);
    int get_node_id(int server_id, const string& node, pqxx::work& pg_db_trans);
	
public:
    
    // ****************
    // Constructor
    // ****************
    /// \brief Initialize the class making use of the pointer to the database 
    /// transaction to determine the output destination.
    //  TODO: allow configure to decide if db functionality is compiled in
    DSCDataManager(const string& server, const string& node, pqxx::work *pg_db_trans);
            
    /// \brief Method to clear the member data. This class is only constructed 
    /// once and repeatedly reused by the DSCIOManager.
    void clear();
    
    /// \brief Method to parse the xml held in a boost::property_tree::ptree
    ///        and populate the member data.
    int load(const boost::property_tree::ptree::value_type &array_value, bool rssac);
    /// \brief Alternate load method that can parse an entire dat file into the 
    /// member data.
    int load(const boost::filesystem::path&, vector<DSCStrategy*>::iterator strategy_it);
    /// \brief Alternate load method that can parse a single line from a dat 
    /// file into the member data.
    int load(const std::string dat_line, vector<DSCStrategy*>::iterator strategy_it);
    /// \brief Process method that is used when processing xml input via  
    /// multiple strategies.
    int process();
    /// \brief Alternate process method that uses a specific strategy to process
    /// the data.
    int process(vector<DSCStrategy*>::iterator strategy_it);
    
};