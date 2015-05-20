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

/* 
 * File:   Format3DSCStrategy.h
 */

#ifndef FORMAT3bDSCSTRATEGY_H
#define FORMAT3bDSCSTRATEGY_H
#include <string>
#include <map>
#include "dsc_types.h"
#include "DSCStrategy.h"
#include "pqxx/pqxx"

using namespace std;

class Format3bDSCStrategy: public DSCStrategy {
    
public:

    Format3bDSCStrategy(string server, string name, string keys[], int keylength);
    virtual ~Format3bDSCStrategy() {};

    void process_to_dat(const DSCUMap &, string dtime[]);
    int process_to_db(const DSCUMap &, string dtime[], int server_id, int node_id, pqxx::work& pg_db_trans);
    int process_dat_line(DSCUMap &/*counts*/, std::string /*time_strings*/[], std::string /*dat_line*/) { return 0; };
    void process_dat_file(DSCUMap &counts, std::string time_strings[], const boost::filesystem::path &file_path);
    void preprocess_data(const DSCUMap &, DSCUMap &, string dtime[], int server_id, int node_id, pqxx::work* pg_db_trans);
    bool is_dat_file_multi_unit() { return false; };

private:

    void write_dat(const DSCUMap &, string dtime[]);
    void write_count_dat(int count, string dtime[]);    
    int write_db(const DSCUMap &, string dtime[], int server_id, int node_id, pqxx::work& pg_db_trans);
    void write_count_db(int count, string dtime[], int server_id, int node_id, pqxx::work& pg_db_trans);
    void read_dat(DSCUMap &);

};

#endif	/* FORMAT3bDSCSTRATEGY_H */

