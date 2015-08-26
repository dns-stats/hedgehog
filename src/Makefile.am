if DM
D = dsc-extractor
S = rssac_server rssac_server/rssac.py rssac_server/threadpool.py
else
D =
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

python_PYTHON = $(S)
EXTRA_DIST = rssac_server.in

do_subst = sed -e 's|@HEDGEHOGYAML@|$(sysconfdir)|'

rssac_server: $(srcdir)/rssac_server/rssac_server.in Makefile
	$(do_subst) < $(srcdir)/rssac_server/rssac_server.in > rssac_server
	chmod 744 rssac_server