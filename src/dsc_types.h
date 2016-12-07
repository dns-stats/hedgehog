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
