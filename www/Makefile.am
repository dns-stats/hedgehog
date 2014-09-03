# TODO: Split this makefile up
# TODO(asap): Install under <prefix>/usr/share
# TODO: misleading error message when trying to remove RPostgreSQLHelper if not there: sudo R CMD REMOVE RPostgreSQLHelper || true

MAINTAINERCLEANFILES = $(srcdir)/Makefile.in

CLEANFILES = $(data_DATA) $(nobase_data_DATA)

sysconfdir = @sysconfdir@/hedgehog

nobase_data_DATA =  hedgehog/conf/hedgehog.conf \
					hedgehog/conf/rssac.yaml \
					hedgehog/www/R/startup.R \
					hedgehog/www/hedgehog.html \
					hedgehog/www/about.html \
					hedgehog/www/brew/hedgehog.brew 
	
nobase_dist_data_DATA = hedgehog/www/images/ajax-loader.gif \
						hedgehog/www/images/apple-touch-icon-114x114.png \
						hedgehog/www/images/apple-touch-icon.png \
						hedgehog/www/images/apple-touch-icon-72x72.png \
						hedgehog/www/images/calendar.png \
						hedgehog/www/images/favicon.ico \
						hedgehog/www/images/none.png \
						hedgehog/www/images/some.png \
						hedgehog/www/images/all.png \
						hedgehog/www/images/info.png \
						hedgehog/www/images/help.png \
						hedgehog/www/js/datetimes.js \
						hedgehog/www/js/gengraph.js \
						hedgehog/www/js/nodetabs.js \
						hedgehog/www/plots/no_graph.png \
						hedgehog/www/plots/no_results.png \
						hedgehog/www/plots/no_connection.png \
						hedgehog/www/R/generatePlot.R \
						hedgehog/www/R/prepareStatement.R \
						hedgehog/www/R/utilities.R \
						hedgehog/www/stylesheets/base.css \
						hedgehog/www/stylesheets/layout.css \
						hedgehog/www/stylesheets/skeleton.css
	
subst_PACKAGEVERSION = sed -e "s,@HH_PACKAGE_VERSION@,@PACKAGE_VERSION@,"
subst_DB_SCHEMA_VERSION = sed -e 's|DB_SCHEMA_VERSION|@DB_SCHEMA_VERSION@|'

hedgehog/conf/hedgehog.conf: $(srcdir)/hedgehog/conf/hedgehog.conf.in Makefile
	mkdir -p hedgehog/conf/
	$(subst_HH_DIRS) < $(srcdir)/hedgehog/conf/hedgehog.conf.in > hedgehog/conf/hedgehog.conf
	
hedgehog/conf/Rapache_hedgehog.load: $(srcdir)/hedgehog/conf/Rapache_hedgehog.load.in Makefile
	mkdir -p hedgehog/conf/
	$(subst_HH_DIRS) < $(srcdir)/hedgehog/conf/Rapache_hedgehog.load.in > hedgehog/conf/Rapache_hedgehog.load
	
hedgehog/www/R/startup.R: $(srcdir)/hedgehog/www/R/startup.R.in Makefile
	mkdir -p hedgehog/www/R/
	$(subst_HH_CONF_FILE) < $(srcdir)/hedgehog/www/R/startup.R.in > hedgehog/www/R/startup.R	
	
hedgehog/www/hedgehog.html: $(srcdir)/hedgehog/www/hedgehog.html.in Makefile
	$(subst_PACKAGEVERSION) < $(srcdir)/hedgehog/www/hedgehog.html.in > hedgehog/www/hedgehog.html
	
hedgehog/www/about.html: $(srcdir)/hedgehog/www/about.html.in Makefile
	$(subst_PACKAGEVERSION) < $(srcdir)/hedgehog/www/about.html.in > hedgehog/www/about.html
	
hedgehog/www/brew/hedgehog.brew: $(srcdir)/hedgehog/www/brew/hedgehog.brew.in Makefile
	mkdir -p hedgehog/www/brew/
	$(subst_DB_SCHEMA_VERSION) < $(srcdir)/hedgehog/www/brew/hedgehog.brew.in | $(subst_HH_DIRS)  > hedgehog/www/brew/hedgehog.brew
	
EXTRA_DIST = 	$(srcdir)/hedgehog/www/hedgehog.html.in \
				$(srcdir)/hedgehog/www/about.html.in \
				$(srcdir)/hedgehog/www/R/startup.R.in \
				$(srcdir)/hedgehog/conf/hedgehog.conf.in \
				$(srcdir)/hedgehog/conf/Rapache_hedgehog.load.in \
				$(srcdir)/hedgehog/www/brew/hedgehog.brew.in
	
install-data-hook:
	sudo R CMD REMOVE RPostgreSQLHelper || true
	sudo R CMD INSTALL $(srcdir)/hedgehog/RPostgreSQLHelper
	test -f @datadir@/$(hh_web_conf_dir)/hedgehog_gui.yaml || \
		${INSTALL_DATA} -m 644 $(srcdir)/$(hh_web_conf_dir)/hedgehog_gui.yaml @datadir@/$(hh_web_conf_dir)
		${INSTALL_DATA} -m 644 $(srcdir)/$(hh_web_conf_dir)/hedgehog_gui.yaml @datadir@/$(hh_web_conf_dir)/hedgehog_gui.yaml.sample

