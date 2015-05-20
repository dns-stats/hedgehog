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
 * File:   dsc_types.h
 */

#ifndef DSC_TYPES_H
#define	DSC_TYPES_H
#define BOOST_FILESYSTEM_NO_DEPRECATED

#include <string>

#include <boost/filesystem.hpp>
#include <boost/filesystem/fstream.hpp>
#include <boost/unordered_map.hpp>

#include <pqxx/pqxx>

using namespace std;
using namespace boost;
namespace bfs = boost::filesystem;

/// \brief Numeration to define valid input sources and output destinations.
enum INPUT_OUTPUT {
    XML,
    DAT,
    PG_DB
};

/// \brief Typedef defining the key pair that is used in the data map.
typedef pair<string, string> DSCKey;

/// \brief Ensure that there is a hash function for use in
/// boost::unordered_map
namespace boost {
    template <>
            class hash<DSCKey> {
            public:
            size_t operator() ( const DSCKey &akey ) const
            {
                size_t v=0;
                boost::hash_combine(v, akey.first);
                boost::hash_combine(v, akey.second);
                return v;
            }
    };
}

/// \brief Typedef defining a map that can hold any type of DSC data.
typedef boost::unordered_map<DSCKey,int> DSCUMap;

/// \brief Structure to hold information about dat files that are being manipulated
/// by the DSC code.
struct dsc_dat_file {
    string filename;
    string tmpfilename;
    bfs::fstream filestream;
    ios_base::openmode open_mode;
};
typedef dsc_dat_file DSCdatfile;


/// \brief Max number of strategies for a given dsc xml array name.
/// 4 is fine for all the current ones.
//#define MAXSTRATEGIES 4

#endif	/* DSC_TYPES_H */
