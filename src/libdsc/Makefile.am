MAINTAINERCLEANFILES = $(srcdir)/Makefile.in

lib_LTLIBRARIES = libdsc.la

libdsc_la_SOURCES =   DSCDataManager.cpp \
                      DSCIOManager.cpp \
                      DSCStrategyFactory.cpp \
                      DSCStrategy.cpp \
                      Format1DSCStrategy.cpp \
                      Format2DSCStrategy.cpp \
                      Format3aDSCStrategy.cpp \
                      Format3bDSCStrategy.cpp \
                      Format4DSCStrategy.cpp

AM_CXXFLAGS = -I$(srcdir)

libdsc_la_CXXFLAGS = @BOOST_CPPFLAGS@ @LIBPQXX_INCLUDES@

libdsc_la_LIBADD =        @BOOST_SYSTEM_LDFLAGS@ \
                          @BOOST_SYSTEM_LIBS@ \
                          @BOOST_FILESYSTEM_LDFLAGS@ \
                          @BOOST_FILESYSTEM_LIBS@ \
                          @BOOST_PROGRAM_OPTIONS_LDFLAGS@ \
                          @BOOST_PROGRAM_OPTIONS_LIBS@ \
                          @LIBPQXX_LIBS@

include_HEADERS =     DSCDataManager.h \
                      DSCStrategyFactory.h \
                      DSCStrategy.h \
                      DSCIOManager.h \
                      Format1DSCStrategy.h \
                      Format2DSCStrategy.h \
                      Format3aDSCStrategy.h \
                      Format3bDSCStrategy.h \
                      Format4DSCStrategy.h \
                      dsc_types.h
