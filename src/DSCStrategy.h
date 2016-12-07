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

/* 
 * File:   DSCStrategy.h
 */

// TODO(asap): Doxygen comments

#ifndef DSCSTRATEGY_H
#define	DSCSTRATEGY_H

#include <string>
#include <set>
#include <map>

#define BOOST_FILESYSTEM_NO_DEPRECATED
#include <boost/filesystem.hpp>
#include <boost/filesystem/fstream.hpp>
#include <boost/unordered_map.hpp>

#include <dsc_types.h>

#include <pqxx/pqxx>

using namespace std;
namespace bfs = boost::filesystem;

class DSCStrategy {

public:
    
    DSCStrategy() {};
    DSCStrategy(string server, string name, string keys[], int keylength);
    
    virtual ~DSCStrategy() {};
    virtual void process_to_dat(const DSCUMap &, string dtime[]) = 0;
    virtual int process_to_db(const DSCUMap &, string dtime[], int server_id, int node_id, pqxx::work& pg_db_trans) = 0;
    virtual int process_dat_line(DSCUMap &counts, std::string time_strings[], std::string dat_line) = 0;
    virtual void process_dat_file(DSCUMap &counts, std::string time_strings[], const boost::filesystem::path &file_path) = 0;
    virtual void preprocess_data(const DSCUMap &, DSCUMap &, string dtime[], int server_id, int node_id, pqxx::work* pg_db_trans) = 0;
    virtual bool is_dat_file_multi_unit() = 0;
    
protected:
    
    set<string> keys_;
    string server_name_;
    string plot_name_;
    DSCdatfile datafile_;
    
    virtual void write_dat(const DSCUMap &, string dtime[]) = 0;
    
    void elsify_unwanted_keys(DSCUMap &dscdata);
    void accum2d_to_count(const DSCUMap &dscdata, DSCUMap &count);
    void accum2d_to_trace(const DSCUMap &dscdata, DSCUMap &trace);
    void swap_dimensions(const DSCUMap &dscdata, DSCUMap &swap);
    void merge_accum2d(const DSCUMap &dscdata, DSCUMap &old);
    void open_file(string dtime[], ios_base::openmode open_mode);
    void close_file();
    void trim_accum2d(DSCUMap  &dscdata);
    int accum1d_to_count(const DSCUMap &dscdata);
    void merge_accum1d(const DSCUMap &dscdata, DSCUMap &accum);
    bool is_valid_time(const string& time_string);    
    int get_plot_id(const string& plot, pqxx::work& pg_db_trans);
    void add_1_to_skipped(const DSCUMap &dscdata, DSCUMap &newdata);
    
};

#endif	/* DSCSTRATEGY_H */

