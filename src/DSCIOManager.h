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

#ifndef DSCIOMANAGER_H
#define	DSCIOMANAGER_H

#define BOOST_FILESYSTEM_NO_DEPRECATED

#include <vector>

#include <boost/property_tree/ptree.hpp>
#include <boost/filesystem.hpp>

#include <pqxx/pqxx>

#include "dsc_types.h"

namespace bfs = boost::filesystem;

/// \brief DSC IO Manager class.
/// 
/// This class is responsible for configuring input and output channels.
/// Provides public functions to activate and deactivate the output destination
/// and to import the data from the source. It only does minimal parsing of any 
/// input data in order to determine how to proceed. The loading of the data 
/// is left to the data manager.
class DSCIOManager
{
private:
    
    // ****************
    // Member data
    // ****************	
    enum INPUT_OUTPUT input_;
    enum INPUT_OUTPUT output_;
    std::string conn_string_;
    std::string file_extension_;
    std::vector<bfs::path> file_vector_;
    pqxx::connection *pg_db_conn_;
    pqxx::work *pg_db_trans_;
    time_t *processing_start_date_;
    bool rssac_;
    // This is not the intended use of a property tree but it works for me
    boost::property_tree::ptree *dsc_xml_;
    
    /// Populate a vector of filenames.
    void dsc_populate_files_vector();
    /// Move data files that have been successfully processed into a done dir.
    void dsc_move_file_to_done(bfs::path path_src);
    /// Decide what to do with a failed file
    void dsc_handle_failed_file(bfs::path path_src, int process);
    ///  Function to test if a file should be excluded from processing
    bool exclude_file(bfs::path path_src, const string& start_of_search_path);
    /// Connect to PostgreSQL database.
    int dsc_connect_pg_db();
    /// Disconnect from PostgreSQL database.
    int dsc_disconnect_pg_db();


public:
    
    // ****************
    // Constructor
    // ****************
    /// \brief Initialize the class. Sets some of the member variables.
    DSCIOManager(const enum INPUT_OUTPUT input, const enum INPUT_OUTPUT output, const string& conn_string, const string& processing_start_date_string, bool rssac);
    virtual ~DSCIOManager();
    /// \brief Activates the output destination (at the moment this only does 
    /// something for the database case).
    void dsc_activate_ouput_destination();
    /// \brief Deactivates the output destination (at the moment this only does 
    /// something for the database case).
    void dsc_deactivate_ouput_destination();
    /// \brief Import data from either XML or DAT files and calls the data 
    /// manager to process and output the data.
    void dsc_import_input_from_source();
};

#endif