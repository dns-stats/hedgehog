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
 * File:   Format4DSCStrategy.h
 */

#ifndef FORMAT4DSCSTRATEGY_H
#define FORMAT4DSCSTRATEGY_H

#include <string>
#include <map>
#include "dsc_types.h"
#include "DSCStrategy.h"
#include "pqxx/pqxx"

using namespace std;

class Format4DSCStrategy: public DSCStrategy {

public:

    Format4DSCStrategy(string server, string name, string keys[], int keylength);
    virtual ~Format4DSCStrategy() {};

    void process_to_dat(const DSCUMap &, string dtime[]);
    int process_to_db(const DSCUMap &, string dtime[], int server_id, int node_id, pqxx::work& pg_db_trans);
    int process_dat_line(DSCUMap &/*counts*/, std::string /*time_strings*/[], std::string /*dat_line*/) { return 0; };
    void process_dat_file(DSCUMap &counts, std::string time_strings[], const boost::filesystem::path &file_path);
    void preprocess_data(const DSCUMap &, DSCUMap &, string dtime[], int server_id, int node_id, pqxx::work* pg_db_trans);
    bool is_dat_file_multi_unit() { return false; };

private:
	
    void write_dat(const DSCUMap &, string dtime[]);
    int write_db(const DSCUMap &, string dtime[], int server_id, int node_id, pqxx::work& pg_db_trans);
    void read_dat(DSCUMap &);

};

#endif	/* FORMAT4DSCSTRATEGY_H */

