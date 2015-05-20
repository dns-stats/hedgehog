bin_PROGRAMS = dsc-extractor

dsc_extractor_SOURCES = dsc-extractor.cpp \
                          DSCDataManager.cpp \
                          DSCIOManager.cpp \
                          DSCStrategyFactory.cpp \
                          DSCStrategy.cpp \
                          Format1DSCStrategy.cpp \
                          Format2DSCStrategy.cpp \
                          Format3aDSCStrategy.cpp \
                          Format3bDSCStrategy.cpp \
                          Format4DSCStrategy.cpp \
                          DSCDataManager.h \
                          DSCStrategyFactory.h \
                          DSCStrategy.h \
                          DSCIOManager.h \
                          Format1DSCStrategy.h \
                          Format2DSCStrategy.h \
                          Format3aDSCStrategy.h \
                          Format3bDSCStrategy.h \
                          Format4DSCStrategy.h \
                          dsc_types.h

dsc_extractor_CXXFLAGS = @LIBPQXX_INCLUDES@ @BOOST_CPPFLAGS@ -I$(top_srcdir)/src/libdsc

dsc_extractor_LDADD = @BOOST_SYSTEM_LDFLAGS@ \
                          @BOOST_SYSTEM_LIBS@ \
                          @BOOST_FILESYSTEM_LDFLAGS@ \
                          @BOOST_FILESYSTEM_LIBS@ \
                          @BOOST_PROGRAM_OPTIONS_LDFLAGS@ \
                          @BOOST_PROGRAM_OPTIONS_LIBS@ \
                          @LIBPQXX_LIBS@
