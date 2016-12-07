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

/// Application which can insert data from DSC XML and DAT files into
/// a PostgreSQL database. It can also convert from XML to DAT.

#include "config.h"
#include <iostream>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#include "dsc_types.h"
#include "DSCIOManager.h"

#define LOCK_FILE       "dsc-extractor.lock"

using namespace std;

/// \brief Usage function that prints usage information.
static void
usage (void)
{
    fprintf(stderr, "Usage: dsc-extractor [OPTION]...\n");
    fprintf(stderr,
        "Supported options:\n"
                "  -h                   Show this usage. \n"
                "  -i                   Input source: [XML|DAT]. Default XML. \n"
                "  -o                   Output destination: [DAT|PG_DB]. Default DAT. \n"
                "  -c                   Connection string for DB. Required. \n"
                "  -s                   Start date for data file processing. Default is to process all data. \n"
                "  -r                   Disable processing of rssac data. Default is to process all data. \n");
    fprintf(stderr, "Version %s. Report bugs to <%s>.\n",
            PACKAGE_VERSION, PACKAGE_BUGREPORT);  
}

/// \brief Main function parses command line and calls the DSCIOManager to load 
/// and convert the data.
int
main(int argc, char *argv[]) {
    int pfp;
    char str[32];
    pid_t pid;
    pid = getpid();
    pfp=open(LOCK_FILE, O_RDWR|O_CREAT, 0640);
    if ( pfp < 0 ) {
        cerr << "Error: Unable to open pid file " << LOCK_FILE << endl;
        exit(1);
    }
    if ( lockf(pfp,F_TLOCK,0) < 0 ) {
        cerr << "Error: Unable to lock pid file " << LOCK_FILE << endl;
        close(pfp);
        exit(0);
    }
    if ( snprintf(str, sizeof(str), "%lu\n", (unsigned long) pid) < 0 ) {
        cerr << "Error: Unable to convert pid to string.\n" << endl;
        close(pfp);
        exit(1);
    }
    if ( write(pfp,str,strlen(str)) < 0 ) {
        cerr << "Error: Unable to write to pid file " << LOCK_FILE << endl;
        close(pfp);
        exit(1);
    }
    
    // default settings that make this code work as a drop in replacement for
    // the original dsc-xml-extractor.pl 
    enum INPUT_OUTPUT input  = XML;
    enum INPUT_OUTPUT output = DAT;
    // connection string to be used if the output is to a database
    string conn_string;
    // string used to determine which date to start processing files from
    string processing_start_date_string;
    // process rssac data by default if present
   bool rssac=true; 
    
    // parse command line options
    int c;
    while ((c = getopt(argc, argv, "hi:o:c:s:r")) != -1) {
        switch (c) {
        case 'h':
            usage();
            exit(0);
        case 'i': {
            string input_string = optarg;
            if (input_string.compare("XML") == 0) {
                input=XML;
            } else if (input_string.compare("DAT") == 0) {
                input=DAT;
            } else {
                cout << "Error: Invalid -i value" << endl;
                usage();
                exit(1);
            }
            break;
        }
        case 'o': {        
            string output_string = optarg;
            if (output_string.compare("DAT") == 0) {
                output=DAT;
            } else if (output_string.compare("PG_DB") == 0) {
                output=PG_DB;
            } else {
                cout << "Error: Invalid -o value" << endl;
                usage();
                exit(1);
            }
            break;
        }    
        case 'c': {
            conn_string = optarg;
            if (conn_string.empty()) {
                cout << "Error: A connection string must be supplied with the -c flag." << endl;
                usage();
                exit(1);
            }
            break;
        }
        case 's': {
            processing_start_date_string = optarg;
            if (processing_start_date_string.empty()) {
                cout << "A processing start date in format YYYY-MM-DD must be provided when using -s." << endl;
                exit(1);
            }
            break;
        }
       case 'r': {
            rssac=false;
            cout << "RSSAC data in the XML will NOT be processed" << endl;
            break;
        }
        case '?': {
            usage();
            exit(1);
        }        
        default: {
            // nothing to do here just go with defaults
            break;
        }    
        }
    }
    
    if (input == output) {
        cout << "Error: Input and output cannot be the same. \n";
        exit(1);
    }   
    if ( input != XML && ! processing_start_date_string.empty()) {
        cerr << "Error: Processing start date option is only supported for input type of XML. Exiting." << endl;
        exit(1);
    }    
    
    try {
        DSCIOManager* data_io_manager = new DSCIOManager(input, output, conn_string, processing_start_date_string, rssac);
        data_io_manager->dsc_activate_ouput_destination();
        data_io_manager->dsc_import_input_from_source();
        data_io_manager->dsc_deactivate_ouput_destination();
        delete data_io_manager;
    }
    catch (std::exception &e) {
        cerr << "Error in libdsc: " << e.what() << endl;
        return 1;
    }
    
    if ( unlink(LOCK_FILE) < 0 ) {
        cerr << "Error: Unable to unlink pid file " << LOCK_FILE << endl;
    }
    return 0;
}
