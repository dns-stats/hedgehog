MAINTAINERCLEANFILES = $(srcdir)/Makefile.in

CLEANFILES = $(bin_SCRIPTS) $(sbin_SCRIPTS)

bin_SCRIPTS = refile_and_grok \
				hedgehogctl

nobase_libexec_SCRIPTS = hedgehog/conf_read \
				hedgehog/database_manage_partitions \
				hedgehog/database_update_nodes \
				hedgehog/datafiles_create_summary \
				hedgehog/datafiles_rm_empty_xml_dirs \
				hedgehog/datafiles_tar_old_xml_files \
				hedgehog/plotcache_generate_cached_plots \
				hedgehog/plotcache_rm_cached_plots \
				hedgehog/rssac_generate_reports \
				hedgehog/rssac_process_unique_source_data \
				hedgehog/rssac_rm_old_unique_source_data \
				hedgehog/database_init \
				DDL_updates/000008_ddl_traffic_difference \
				DDL_updates/000009_ddl_node_index

nobase_data_DATA = $(srcdir)/hedgehog/sql/initialise_database.sql \
				$(srcdir)/hedgehog/sql/insert_lookup_data.sql

subst_S_BIN = sed -e "s,@SBIN@,@sbindir@,"  -e "s,@BIN@,@libexecdir@," -e "s,@DATA@,@datadir@,"
subst_DB_VERSION = sed -e "s|DB_VERSION|@DB_SCHEMA_VERSION@|"
subst_libexec = sed -e "s|@LIBEXEC@|@libexecdir@|"

hedgehogctl: hedgehogctl.in Makefile
	${subst_libexec} < $(srcdir)/hedgehogctl.in > hedgehogctl

refile_and_grok: refile_and_grok.in Makefile
	$(subst_S_BIN) < $(srcdir)/refile_and_grok.in | $(subst_DB_VERSION) > refile_and_grok

hedgehog/conf_read: $(srcdir)/hedgehog/conf_read.in Makefile
	mkdir -p hedgehog
	$(subst_HH_CONF_FILE) < $(srcdir)/hedgehog/conf_read.in > hedgehog/conf_read
	
hedgehog/database_init: $(srcdir)/hedgehog/database_init.in Makefile
	mkdir -p hedgehog
	$(subst_S_BIN) < $(srcdir)/hedgehog/database_init.in > hedgehog/database_init

hedgehog/database_manage_partitions: $(srcdir)/hedgehog/database_manage_partitions.in Makefile
	mkdir -p hedgehog
	$(subst_DB_VERSION) < $(srcdir)/hedgehog/database_manage_partitions.in | $(subst_S_BIN) > hedgehog/database_manage_partitions
	
hedgehog/database_update_nodes: $(srcdir)/hedgehog/database_update_nodes.in Makefile
	mkdir -p hedgehog
	$(subst_DB_VERSION) < $(srcdir)/hedgehog/database_update_nodes.in | $(subst_S_BIN) > hedgehog/database_update_nodes
	
hedgehog/datafiles_create_summary: $(srcdir)/hedgehog/datafiles_create_summary.in Makefile
	mkdir -p hedgehog
	$(subst_S_BIN) < $(srcdir)/hedgehog/datafiles_create_summary.in > hedgehog/datafiles_create_summary
	
hedgehog/datafiles_rm_empty_xml_dirs: $(srcdir)/hedgehog/datafiles_rm_empty_xml_dirs.in Makefile
	mkdir -p hedgehog
	$(subst_S_BIN) < $(srcdir)/hedgehog/datafiles_rm_empty_xml_dirs.in > hedgehog/datafiles_rm_empty_xml_dirs

hedgehog/datafiles_tar_old_xml_files: $(srcdir)/hedgehog/datafiles_tar_old_xml_files.in Makefile
	mkdir -p hedgehog
	$(subst_S_BIN) < $(srcdir)/hedgehog/datafiles_tar_old_xml_files.in > hedgehog/datafiles_tar_old_xml_files

hedgehog/plotcache_generate_cached_plots: $(srcdir)/hedgehog/plotcache_generate_cached_plots.in Makefile
	mkdir -p hedgehog
	$(subst_DB_VERSION) < $(srcdir)/hedgehog/plotcache_generate_cached_plots.in | $(subst_S_BIN) > hedgehog/plotcache_generate_cached_plots

hedgehog/plotcache_rm_cached_plots: $(srcdir)/hedgehog/plotcache_rm_cached_plots.in Makefile
	mkdir -p hedgehog
	$(subst_S_BIN) < $(srcdir)/hedgehog/plotcache_rm_cached_plots.in | $(subst_DB_VERSION) > hedgehog/plotcache_rm_cached_plots
	
hedgehog/rssac_generate_reports: $(srcdir)/hedgehog/rssac_generate_reports.in Makefile
	mkdir -p hedgehog
	$(subst_DB_VERSION) < $(srcdir)/hedgehog/rssac_generate_reports.in | $(subst_S_BIN) > hedgehog/rssac_generate_reports
	
hedgehog/rssac_process_unique_source_data: $(srcdir)/hedgehog/rssac_process_unique_source_data.in Makefile
	mkdir -p hedgehog
	$(subst_DB_VERSION) < $(srcdir)/hedgehog/rssac_process_unique_source_data.in | $(subst_S_BIN) > hedgehog/rssac_process_unique_source_data
	
hedgehog/rssac_rm_old_unique_source_data: $(srcdir)/hedgehog/rssac_rm_old_unique_source_data.in Makefile
	mkdir -p hedgehog
	$(subst_DB_VERSION) < $(srcdir)/hedgehog/rssac_rm_old_unique_source_data.in | $(subst_S_BIN) > hedgehog/rssac_rm_old_unique_source_data
	
DDL_updates/000008_ddl_traffic_difference: $(srcdir)/DDL_updates/000008_ddl_traffic_difference.in Makefile
	mkdir -p DDL_updates
	$(subst_DB_VERSION) < $(srcdir)/DDL_updates/000008_ddl_traffic_difference.in | $(subst_S_BIN) > DDL_updates/000008_ddl_traffic_difference

DDL_updates/000009_ddl_node_index: $(srcdir)/DDL_updates/000009_ddl_node_index.in Makefile
	mkdir -p DDL_updates
	$(subst_DB_VERSION) < $(srcdir)/DDL_updates/000009_ddl_node_index.in | $(subst_S_BIN) > DDL_updates/000009_ddl_node_index

EXTRA_DIST = 	refile_and_grok.in \
				conf_read.in \
				database_init.in \
				database_manage_partitions.in \
				database_update_nodes.in \
				datafiles_create_summary.in \
				datafiles_rm_empty_xml_dirs.in \
				datafiles_tar_old_xml_files.in \
				plotcache_generate_cached_plots.in \
				plotcache_rm_cached_plots.in \
				rssac_generate_reports.in \
				rssac_process_unique_source_data.in \
				rssac_rm_old_unique_source_data.in 
	
install-data-hook:
	mkdir -p ${DESTDIR}$(localstatedir)/hedgehog
	chmod -R 775 ${DESTDIR}$(localstatedir)/hedgehog
