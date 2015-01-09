MAINTAINERCLEANFILES = $(srcdir)/Makefile.in

CLEANFILES = $(bin_SCRIPTS) $(sbin_SCRIPTS)

bin_SCRIPTS = 	refile_and_grok.sh \
				hedgehog_conf_read.sh \
				hedgehog_database_manage_partitions.sh \
				hedgehog_database_update_nodes.sh \
				hedgehog_datafiles_create_summary.sh \
				hedgehog_datafiles_rm_empty_xml_dirs.sh \
				hedgehog_datafiles_tar_old_xml_files.sh \
				hedgehog_plotcache_generate_cached_plots.sh \
				hedgehog_plotcache_rm_cached_plots.sh \
				hedgehog_rssac_generate_reports.sh \
				hedgehog_rssac_process_unique_source_data.sh \
				hedgehog_rssac_rm_old_unique_source_data.sh 

sbin_SCRIPTS = 	hedgehog_database_create.sh 

nobase_data_DATA = $(srcdir)/hedgehog/sql/initialise_database.sql \
				   $(srcdir)/hedgehog/sql/insert_lookup_data.sql

subst_S_BIN = sed -e "s,@SBIN@,@sbindir@,"  -e "s,@BIN@,@bindir@," -e "s,@DATA@,@datadir@,"
subst_DB_VERSION = sed -e "s|DB_VERSION|@DB_SCHEMA_VERSION@|"

refile_and_grok.sh: refile_and_grok.sh.in Makefile
	$(subst_S_BIN) < $(srcdir)/refile_and_grok.sh.in | $(subst_DB_VERSION) > refile_and_grok.sh
	
hedgehog_conf_read.sh: hedgehog_conf_read.sh.in Makefile
	$(subst_HH_CONF_FILE) < $(srcdir)/hedgehog_conf_read.sh.in > hedgehog_conf_read.sh
	
hedgehog_database_create.sh: hedgehog_database_create.sh.in Makefile
	$(subst_S_BIN) < $(srcdir)/hedgehog_database_create.sh.in > hedgehog_database_create.sh

hedgehog_database_manage_partitions.sh: hedgehog_database_manage_partitions.sh.in Makefile
	$(subst_DB_VERSION) < $(srcdir)/hedgehog_database_manage_partitions.sh.in | $(subst_S_BIN) > hedgehog_database_manage_partitions.sh
	
hedgehog_database_update_nodes.sh: hedgehog_database_update_nodes.sh.in Makefile
	$(subst_DB_VERSION) < $(srcdir)/hedgehog_database_update_nodes.sh.in | $(subst_S_BIN) > hedgehog_database_update_nodes.sh
	
hedgehog_datafiles_create_summary.sh: hedgehog_datafiles_create_summary.sh.in Makefile
	$(subst_S_BIN) < $(srcdir)/hedgehog_datafiles_create_summary.sh.in > hedgehog_datafiles_create_summary.sh
	
hedgehog_datafiles_rm_empty_xml_dirs.sh: hedgehog_datafiles_rm_empty_xml_dirs.sh.in Makefile
	$(subst_S_BIN) < $(srcdir)/hedgehog_datafiles_rm_empty_xml_dirs.sh.in > hedgehog_datafiles_rm_empty_xml_dirs.sh

hedgehog_datafiles_tar_old_xml_files.sh: hedgehog_datafiles_tar_old_xml_files.sh.in Makefile
	$(subst_S_BIN) < $(srcdir)/hedgehog_datafiles_tar_old_xml_files.sh.in > hedgehog_datafiles_tar_old_xml_files.sh
	
hedgehog_plotcache_generate_cached_plots.sh: hedgehog_plotcache_generate_cached_plots.sh.in Makefile
	$(subst_DB_VERSION) < $(srcdir)/hedgehog_plotcache_generate_cached_plots.sh.in | $(subst_S_BIN) > hedgehog_plotcache_generate_cached_plots.sh

hedgehog_plotcache_rm_cached_plots.sh: hedgehog_plotcache_rm_cached_plots.sh.in Makefile
	$(subst_S_BIN) < $(srcdir)/hedgehog_plotcache_rm_cached_plots.sh.in | $(subst_DB_VERSION) > hedgehog_plotcache_rm_cached_plots.sh
	
hedgehog_rssac_generate_reports.sh: hedgehog_rssac_generate_reports.sh.in Makefile
	$(subst_DB_VERSION) < $(srcdir)/hedgehog_rssac_generate_reports.sh.in | $(subst_S_BIN) > hedgehog_rssac_generate_reports.sh
	
hedgehog_rssac_process_unique_source_data.sh: hedgehog_rssac_process_unique_source_data.sh.in Makefile
	$(subst_DB_VERSION) < $(srcdir)/hedgehog_rssac_process_unique_source_data.sh.in | $(subst_S_BIN) > hedgehog_rssac_process_unique_source_data.sh
	
hedgehog_rssac_rm_old_unique_source_data.sh: hedgehog_rssac_rm_old_unique_source_data.sh.in Makefile
	$(subst_DB_VERSION) < $(srcdir)/hedgehog_rssac_rm_old_unique_source_data.sh.in | $(subst_S_BIN) > hedgehog_rssac_rm_old_unique_source_data.sh
	
EXTRA_DIST = 	refile_and_grok.sh.in \
				hedgehog_conf_read.sh.in \
				hedgehog_database_create.sh.in \
				hedgehog_database_manage_partitions.sh.in \
				hedgehog_database_update_nodes.sh.in \
				hedgehog_datafiles_create_summary.sh.in \
				hedgehog_datafiles_rm_empty_xml_dirs.sh.in \
				hedgehog_datafiles_tar_old_xml_files.sh.in \
				hedgehog_plotcache_generate_cached_plots.sh.in \
				hedgehog_plotcache_rm_cached_plots.sh.in \
				hedgehog_rssac_generate_reports.sh.in \
				hedgehog_rssac_process_unique_source_data.sh.in \
				hedgehog_rssac_rm_old_unique_source_data.sh.in 
	
install-data-hook:
	mkdir -p ${DESTDIR}$(localstatedir)/hedgehog
	chmod -R 775 ${DESTDIR}$(localstatedir)/hedgehog
