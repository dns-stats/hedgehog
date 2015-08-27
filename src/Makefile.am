if DM
D = dsc-extractor
P = rssac_server.py rssac_server/rssac.py rssac_server/threadpool.py
S = rssacd
else
D =
P =
S =
endif

sysconfdir = @sysconfdir@/hedgehog

bin_PROGRAMS = $(D)

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

python_PYTHON = $(P)
sbin_SCRIPTS = $(S)
EXTRA_DIST = rssac_server.in rssacd.in

do_subst_hh = sed -e 's|@HEDGEHOGYAML@|$(sysconfdir)|' -e "s|@DB_VERSION@|@DB_SCHEMA_VERSION@|"
do_subst_python = sed -e 's|@PYTHON_EXE@|$(PYTHON)|' -e 's|@HHPYSITEDIR@|$(pythondir)|'

rssac_server.py: $(srcdir)/rssac_server/rssac_server.in Makefile
	$(do_subst_hh) < $(srcdir)/rssac_server/rssac_server.in > rssac_server.py
	
rssacd: $(srcdir)/rssac_server/rssacd.in Makefile
	$(do_subst_python) < $(srcdir)/rssac_server/rssacd.in > rssacd
