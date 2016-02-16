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

dist_man_MANS = rssacd.8 \
                dsc-extractor.1

rssacd.8: rssacd rssac_server.py rssac_server/rssac.py rssac_server/threadpool.py Makefile
	chmod 755 rssacd
	PYTHONPATH=${srcdir}/rssac_server $(HELP2MAN) --version-string=@PACKAGE_VERSION@ -N -s 8 -n "This listens for DNS Notify messages and records the zone size and the time for propogation of zones. This is only needed for the generation of RSSAC reports" ./rssacd -o rssacd.8

dsc-extractor.1: dsc-extractor Makefile
	$(HELP2MAN) -h -h --version-string=@PACKAGE_VERSION@ -N -s 1 --no-discard-stderr -n "Application to extract DSC data from XML or DAT files and insert it in to a Postgresql database. Users are recommended to use the refile_and_grok wrapper script in preference to using this exectutable directly." ./dsc-extractor -o dsc-extractor.1
	
install-data-hook:
	mkdir -p ${DESTDIR}${sysconfdir}/init.d
	cp ${srcdir}/rssac_server/rssacd.init ${DESTDIR}${sysconfdir}/init.d/rssacd
	chmod 755 ${DESTDIR}${sysconfdir}/init.d/rssacd
		