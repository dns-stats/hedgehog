MAINTAINERCLEANFILES = $(srcdir)/Makefile.in

noinst_LIBRARIES = libdsc.a

libdsc_a_SOURCES =   DSCDataManager.cpp \
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

AM_CXXFLAGS = -I$(srcdir)

libdsc_a_CXXFLAGS = @BOOST_CPPFLAGS@ @LIBPQXX_INCLUDES@
