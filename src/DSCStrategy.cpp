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
#include <string>
#include <set>
#include <map>

#define BOOST_FILESYSTEM_NO_DEPRECATED
#include <boost/filesystem.hpp>
#include <boost/filesystem/fstream.hpp>
#include <boost/unordered_map.hpp>
#include <boost/lexical_cast.hpp>

#include "dsc_types.h"
#include "DSCStrategy.h"

#include "pqxx/pqxx"

using namespace std;
namespace bfs = boost::filesystem;

DSCStrategy::DSCStrategy(string server, string name, string keys[], int keylength) {

    if ( keylength != 0 ) keys_.insert (keys, keys+keylength);
    server_name_ = server;
    plot_name_ = name;

}

bool
DSCStrategy::is_valid_time(const string& time_string) {

    bool res = true;
    try {
        boost::lexical_cast<time_t>(time_string);
    if (time_string.size() != 10 ) res = false;
    }
    catch (boost::bad_lexical_cast &e) {
        res = false;
    }
    
    return(res);

}

void
DSCStrategy::elsify_unwanted_keys(DSCUMap &dscdata) {

    // elsify_unwanted_keys
    DSCUMap::iterator it=dscdata.begin();
    
    boost::unordered_map<string,int> tmp_value;
    boost::unordered_map<string,int>::iterator it1;
    while ( it != dscdata.end() ) {
        // skip if map key (second part) is else
        // skip if map key (second part) is in the list of valid 
        // keys for this graph
        if ( ((*it).first.second == "else") || (keys_.find((*it).first.second) != keys_.end()) ) {
            it++;
            continue;
        }
        // Sum the values of the unknown keys 
        // and then delete the unknown key.
        // Don't forget we are in an iterator and so must post increment it
        tmp_value[(*it).first.first] += (*it).second;
        dscdata.erase(it++);
    }
    
    it1 = tmp_value.begin();
    for(; it1 != tmp_value.end(); it1++) {
        DSCKey tmp_key1((*it1).first,"else");
        if ((*it1).second !=  0) {
            dscdata[tmp_key1] += (*it1).second;
        }
    }

}

int
DSCStrategy::accum1d_to_count(const DSCUMap &dscdata) {

    int count=0;
    DSCUMap::const_iterator it=dscdata.begin();
    for ( ; it!=dscdata.end() ; it++){
        if ((*it).first.second == "-:SKIPPED_SUM:-") {
            continue;
        } else if ((*it).first.second == "-:SKIPPED:-") {
            count += (*it).second;
        } else {
            count++;
        }
    }
    return count;

}

void
DSCStrategy::merge_accum1d(const DSCUMap &dscdata, DSCUMap &accum){

    DSCKey tmp_key;
    tmp_key.first = "All";
    DSCUMap::const_iterator it=dscdata.begin();
    for ( ; it!=dscdata.end() ; it++){
        tmp_key.second = (*it).first.second;
        accum[tmp_key] += (*it).second;
    }

}

// convert a "2D" accum-type dataset to a "count-type"
// ie, count all input->{*}{k2} into output->{k2}
void
DSCStrategy::accum2d_to_count(const DSCUMap &dscdata, DSCUMap &count) {
    
    DSCUMap::const_iterator it=dscdata.begin();
    DSCKey tmp_key;
    while ( it != dscdata.end() ) {
        if ( (*it).first.second == "-:SKIPPED_SUM:-" ) { 
       
        } else if ( (*it).first.second == "-:SKIPPED:-" ) {
            tmp_key.first = "All";
            tmp_key.second = (*it).first.first;
            count[tmp_key] += (*it).second;
        } else {
            tmp_key.first = "All";
            tmp_key.second = (*it).first.first;
            count[tmp_key] += 1;
        }
        it++;
    }

}

// convert a "2D" accum-type dataset to a trace-type
// ie, sum all input->{*}{k2} into output->{k2}
void
DSCStrategy::accum2d_to_trace(const DSCUMap &dscdata, DSCUMap &trace){

    DSCUMap::const_iterator it=dscdata.begin();
    DSCKey tmp_key;
    while ( it != dscdata.end() ) {
        if ( (*it).first.second != "-:SKIPPED:-" ) {
            tmp_key.first = "All";
            tmp_key.second = (*it).first.first;
            trace[tmp_key] += (*it).second;
        }
        it++;
        
    }

}

void
DSCStrategy::swap_dimensions(const DSCUMap &dscdata, DSCUMap &swap) {

    DSCUMap::const_iterator it=dscdata.begin();
    DSCKey tmp_key;
    while ( it != dscdata.end() ) {
        tmp_key.first = (*it).first.second;
        tmp_key.second = (*it).first.first;
        swap[tmp_key] = (*it).second;
        it++;
    }
    if ( swap.size() != dscdata.size() ) cout << "Error swapping keys\n";

}

void
DSCStrategy::merge_accum2d(const DSCUMap &dscdata, DSCUMap &old) {

    DSCUMap::const_iterator it=dscdata.begin();
    for ( ; it != dscdata.end() ; it++ ) old[(*it).first] += (*it).second;

}

void
DSCStrategy::trim_accum2d(DSCUMap &dscdata) {

    // key order has been swapped before getting here
    // dscdata -> (TLD, QTYPE) -> count)
    multimap<int,string> r_map;
    multimap<int,string>::reverse_iterator ir;
    set<DSCKey> keys2delete;
    
    // iterate over allowed keys
    set<string>::iterator key = keys_.begin();
    for (; key != keys_.end() ; key++ ) {
        
        int n = 0;
        // iterate over dscdata and create multimap
        // r_map = count -> TLD (sorted))
        DSCUMap::iterator it=dscdata.begin();
        for (; it != dscdata.end() ; it++) {   
            if ((*it).first.second != (*key) ) continue;
            // use multimap to sort by value
            r_map.insert(pair<int,string>((*it).second,(*it).first.first));
        }
        // iterate over r_map
        ir=r_map.rbegin();
        for (; ir != r_map.rend() ; ir++) {
            // Create key_pair
            // TLD,allowed key
            DSCKey key_pair ((*ir).second,*key);
            // continue if n <= 1000 
            //  this means that we have seen 1000 or more (TLD,allowed key) pairs
            if ( ++n <= 1000 ) continue;
            // continue if key_pair is not found in dscdata
            if ( dscdata.find(key_pair) == dscdata.end() ) continue;
            // so now we have TLD,allowed key pairs above 1000
            // for each one add one to dscdata("-:SKIPPED:-", allowed key)  value
            DSCKey tmp_skip ("-:SKIPPED:-",*key);
            dscdata[tmp_skip]++;        
            // and add the value to a dscdata("-:SKIPPED_SUM:-", allowed key)  value
            DSCKey tmp_skip_sum ("-:SKIPPED_SUM:-",*key);
            dscdata[tmp_skip_sum] += dscdata[key_pair];
            // Add the (TLD,allowed key pair) to a set of keys to be deleted later
            keys2delete.insert(key_pair);
        }
        r_map.clear();
        // and finally delete the dscdata entries in set keys2delete
        set<DSCKey>::iterator it1 = keys2delete.begin();
        for (; it1 != keys2delete.end(); it1++) {
            dscdata.erase((*it1));
        }
        keys2delete.clear();
    }
    return;

}

void
DSCStrategy::open_file(string dtime[], ios_base::openmode open_mode) {

    bfs::path p_tmp;
    bfs::path p_tmp_file;
    bfs::path p_unique;
    bfs::path p_data_root = ".";
    bfs::path p_storage = dtime[0];
    bfs::path p_data_storage(p_data_root/p_storage);
    bfs::path p_filename(plot_name_ + ".dat");
    bfs::path p_dat_file(p_data_storage/p_filename);
    
    if ( open_mode & ios_base::app || open_mode & ios_base::trunc || open_mode & ios_base::out) {
        p_unique = bfs::unique_path();
        p_tmp_file = plot_name_ + ".dat." + p_unique.string();
        p_tmp = p_data_storage/p_tmp_file;
    }

    try {
        
        if (! bfs::exists(p_data_storage)) bfs::create_directory(p_data_storage);
        if (! bfs::exists(p_data_storage)) {
            cerr <<  "FS Error: " << p_data_storage << " directory could not be created." << endl;
            return;
        }
        if (! bfs::is_directory(p_data_storage)) {
            cerr <<  "FS Error: " <<  p_data_storage << " exists but is not a directory." << endl;
            return;
        }
        
        if ( open_mode & ios_base::app || open_mode & ios_base::trunc || open_mode & ios_base::out) {
            if (bfs::exists(p_dat_file)) bfs::copy_file(p_dat_file, p_tmp);
            datafile_.filename=p_dat_file.string();
            datafile_.tmpfilename=p_tmp.string();
            datafile_.open_mode = open_mode;
            datafile_.filestream.open(p_tmp, open_mode);
            if (! datafile_.filestream.is_open()) {
                cerr <<  "FS Error: " << p_tmp << " temporary file did not open." << endl;
                return;
            }
        } else if ( open_mode & ios_base::in ) {
            datafile_.filename=p_dat_file.string();
            datafile_.open_mode = open_mode;
            datafile_.filestream.open(p_dat_file, open_mode);
            if (bfs::exists(p_dat_file) && (! datafile_.filestream.is_open()))  {
                cerr <<  "FS Error: " << p_dat_file << " dat file did not open." << endl;
                return;
            }
        } else {
            cerr << "FS Error: un-supported file open mode" << endl;
        }
    }
    catch (const bfs::filesystem_error& ex) {
        cerr << "FS Error: " << ex.what() << endl;
    }
    return;

}

void
DSCStrategy::close_file() {

    try {
        datafile_.filestream.close();
        if (datafile_.open_mode & ios_base::app || datafile_.open_mode & ios_base::trunc || datafile_.open_mode & ios_base::out) {
            bfs::rename(datafile_.tmpfilename, datafile_.filename);
        }
    }
    catch (const bfs::filesystem_error& ex) {
        cerr << "FS Error: " << ex.what() << endl;
    }

}

int
DSCStrategy::get_plot_id(const string& plot, pqxx::work& pg_db_trans) {

    stringstream sql;
    pqxx::result r;
    
    try {
        sql.clear();
        sql.str("");
        sql << "SELECT id FROM dsc.dataset WHERE name = '" << plot << "'" << endl;
        r = pg_db_trans.exec(sql.str());
        if ( r.size() != 1 ) {
            cerr << "Error: Expected 1 plot with name " << plot << ", "
                 << "but found " << r.size() << endl;
            exit( EXIT_FAILURE );
        }
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
    return r[0][0].as<int>();

}

