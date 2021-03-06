CLEANFILES = $(bin_SCRIPTS)

bin_SCRIPTS = refile_and_grok \
              hedgehog/hedgehog_database_create \
              hedgehogctl

nobase_libexec_SCRIPTS = hedgehog/conf_read \
                         hedgehog/check_user_perms \
                         hedgehog/database_init \
                         hedgehog/database_manage_partitions \
                         hedgehog/database_update_geoip \
                         hedgehog/database_update_nodes \
                         hedgehog/database_update_service_addr \
                         hedgehog/database_update_tlds \
                         hedgehog/database_update_tlds_from_zone \
                         hedgehog/datafiles_create_summary \
                         hedgehog/datafiles_rm_empty_xml_dirs \
                         hedgehog/datafiles_tar_old_xml_files \
                         hedgehog/plotcache_generate_cached_plots \
                         hedgehog/plotcache_rm_cached_plots \
                         hedgehog/rssac_generate_reports \
                         hedgehog/database_process_rssac_data \
                         hedgehog/database_rm_old_rssac_data \
                         hedgehog/DDL_updates/000010_ddl_python \
                         hedgehog/DDL_updates/000011_ddl_new_graphs \
                         hedgehog/DDL_updates/000012_ddl_lower_key_index \
                         hedgehog/DDL_updates/000013_ddl_dnskey_vs_asn \
                         hedgehog/DDL_updates/000014_ddl_service_addr \
                         hedgehog/DDL_updates/000015_ddl_byregion \
                         hedgehog/DDL_updates/000016_ddl_server_addr_vs_trans \
                         hedgehog/DDL_updates/000017_ddl_node_stats \
                         hedgehog/utility_prepare_GeoLite2-City-Blocks-IPvX \
                         hedgehog/utility_prepare_GeoLite2-City-Locations-en

nobase_data_DATA = $(srcdir)/hedgehog/sql/initialise_database.sql \
                   $(srcdir)/hedgehog/sql/insert_lookup_data.sql \
                   $(srcdir)/hedgehog/sql/dns.sql

subst_LIBEXECDATA = sed -e "s|@LIBEXEC@|@libexecdir@/hedgehog|" -e "s|@DATA@|@datadir@|"
subst_DB_VERSION = sed -e "s|@DB_VERSION@|@DB_SCHEMA_VERSION@|"
subst_BIN = sed -e "s|@BIN@|@bindir@|"
do_subst_python = sed -e 's|@PYTHON_EXE@|$(PYTHON)|' -e 's|@HHPYSITEDIR@|$(pythondir)|'
subst_sql = sed -e 's|<SQL_PATH>|$(datadir)/hedgehog/sql|'
subst_version = sed -e 's|<VERSION>|@VERSION@|'

hedgehog/utility_prepare_GeoLite2-City-Blocks-IPvX: $(srcdir)/hedgehog/utility_prepare_GeoLite2-City-Blocks-IPvX.in Makefile
	$(do_subst_python) < $(srcdir)/hedgehog/utility_prepare_GeoLite2-City-Blocks-IPvX.in > hedgehog/utility_prepare_GeoLite2-City-Blocks-IPvX

hedgehog/utility_prepare_GeoLite2-City-Locations-en: $(srcdir)/hedgehog/utility_prepare_GeoLite2-City-Locations-en.in Makefile
	$(do_subst_python) < $(srcdir)/hedgehog/utility_prepare_GeoLite2-City-Locations-en.in > hedgehog/utility_prepare_GeoLite2-City-Locations-en
	
refile_and_grok: refile_and_grok.in Makefile
	$(subst_LIBEXECDATA) < $(srcdir)/refile_and_grok.in | $(subst_BIN) > refile_and_grok

hedgehogctl: hedgehogctl.in Makefile
	$(subst_LIBEXECDATA) < $(srcdir)/hedgehogctl.in > hedgehogctl

hedgehog/conf_read: $(srcdir)/hedgehog/conf_read.in Makefile
	mkdir -p hedgehog
	$(subst_HH_CONF_FILE) < $(srcdir)/hedgehog/conf_read.in > hedgehog/conf_read

hedgehog/check_user_perms: $(srcdir)/hedgehog/check_user_perms.in Makefile
	mkdir -p hedgehog
	$(subst_DB_VERSION) < $(srcdir)/hedgehog/check_user_perms.in | $(subst_LIBEXECDATA) | $(subst_version) > hedgehog/check_user_perms
	
hedgehog/database_init: $(srcdir)/hedgehog/database_init.in Makefile
	mkdir -p hedgehog
	$(subst_LIBEXECDATA) < $(srcdir)/hedgehog/database_init.in > hedgehog/database_init

hedgehog/database_manage_partitions: $(srcdir)/hedgehog/database_manage_partitions.in Makefile
	mkdir -p hedgehog
	$(subst_LIBEXECDATA) < $(srcdir)/hedgehog/database_manage_partitions.in > hedgehog/database_manage_partitions

hedgehog/database_update_geoip: $(srcdir)/hedgehog/database_update_geoip.in Makefile
	mkdir -p hedgehog
	$(subst_LIBEXECDATA) < $(srcdir)/hedgehog/database_update_geoip.in > hedgehog/database_update_geoip

hedgehog/database_update_nodes: $(srcdir)/hedgehog/database_update_nodes.in Makefile
	mkdir -p hedgehog
	$(subst_LIBEXECDATA) < $(srcdir)/hedgehog/database_update_nodes.in > hedgehog/database_update_nodes

hedgehog/database_update_service_addr: $(srcdir)/hedgehog/database_update_service_addr.in Makefile
	mkdir -p hedgehog
	$(subst_LIBEXECDATA) < $(srcdir)/hedgehog/database_update_service_addr.in > hedgehog/database_update_service_addr

hedgehog/database_update_tlds: $(srcdir)/hedgehog/database_update_tlds.in Makefile
	mkdir -p hedgehog
	$(subst_LIBEXECDATA) < $(srcdir)/hedgehog/database_update_tlds.in > hedgehog/database_update_tlds

hedgehog/database_update_tlds_from_zone: $(srcdir)/hedgehog/database_update_tlds_from_zone.in Makefile
	mkdir -p hedgehog
	$(subst_LIBEXECDATA) < $(srcdir)/hedgehog/database_update_tlds_from_zone.in > hedgehog/database_update_tlds_from_zone

hedgehog/datafiles_create_summary: $(srcdir)/hedgehog/datafiles_create_summary.in Makefile
	mkdir -p hedgehog
	$(subst_LIBEXECDATA) < $(srcdir)/hedgehog/datafiles_create_summary.in > hedgehog/datafiles_create_summary

hedgehog/datafiles_rm_empty_xml_dirs: $(srcdir)/hedgehog/datafiles_rm_empty_xml_dirs.in Makefile
	mkdir -p hedgehog
	$(subst_LIBEXECDATA) < $(srcdir)/hedgehog/datafiles_rm_empty_xml_dirs.in > hedgehog/datafiles_rm_empty_xml_dirs

hedgehog/datafiles_tar_old_xml_files: $(srcdir)/hedgehog/datafiles_tar_old_xml_files.in Makefile
	mkdir -p hedgehog
	$(subst_LIBEXECDATA) < $(srcdir)/hedgehog/datafiles_tar_old_xml_files.in > hedgehog/datafiles_tar_old_xml_files

hedgehog/plotcache_generate_cached_plots: $(srcdir)/hedgehog/plotcache_generate_cached_plots.in Makefile
	mkdir -p hedgehog
	$(subst_LIBEXECDATA) < $(srcdir)/hedgehog/plotcache_generate_cached_plots.in > hedgehog/plotcache_generate_cached_plots

hedgehog/plotcache_rm_cached_plots: $(srcdir)/hedgehog/plotcache_rm_cached_plots.in Makefile
	mkdir -p hedgehog
	$(subst_LIBEXECDATA) < $(srcdir)/hedgehog/plotcache_rm_cached_plots.in > hedgehog/plotcache_rm_cached_plots

hedgehog/rssac_generate_reports: $(srcdir)/hedgehog/rssac_generate_reports.in Makefile
	mkdir -p hedgehog
	$(subst_LIBEXECDATA) < $(srcdir)/hedgehog/rssac_generate_reports.in > hedgehog/rssac_generate_reports

hedgehog/database_process_rssac_data: $(srcdir)/hedgehog/database_process_rssac_data.in Makefile
	mkdir -p hedgehog
	$(subst_LIBEXECDATA) < $(srcdir)/hedgehog/database_process_rssac_data.in > hedgehog/database_process_rssac_data

hedgehog/database_rm_old_rssac_data: $(srcdir)/hedgehog/database_rm_old_rssac_data.in Makefile
	mkdir -p hedgehog
	$(subst_LIBEXECDATA) < $(srcdir)/hedgehog/database_rm_old_rssac_data.in > hedgehog/database_rm_old_rssac_data

hedgehog/DDL_updates/000010_ddl_python: $(srcdir)/hedgehog/DDL_updates/000010_ddl_python.in Makefile
	mkdir -p hedgehog/DDL_updates
	$(subst_LIBEXECDATA) < $(srcdir)/hedgehog/DDL_updates/000010_ddl_python.in | $(subst_DB_VERSION) | $(subst_sql) > hedgehog/DDL_updates/000010_ddl_python

hedgehog/DDL_updates/000011_ddl_new_graphs: $(srcdir)/hedgehog/DDL_updates/000011_ddl_new_graphs.in Makefile
	mkdir -p hedgehog/DDL_updates
	$(subst_LIBEXECDATA) < $(srcdir)/hedgehog/DDL_updates/000011_ddl_new_graphs.in | $(subst_DB_VERSION) > hedgehog/DDL_updates/000011_ddl_new_graphs

hedgehog/DDL_updates/000012_ddl_lower_key_index: $(srcdir)/hedgehog/DDL_updates/000012_ddl_lower_key_index.in Makefile
	mkdir -p hedgehog/DDL_updates
	$(subst_LIBEXECDATA) < $(srcdir)/hedgehog/DDL_updates/000012_ddl_lower_key_index.in | $(subst_DB_VERSION) > hedgehog/DDL_updates/000012_ddl_lower_key_index

hedgehog/DDL_updates/000013_ddl_dnskey_vs_asn: $(srcdir)/hedgehog/DDL_updates/000013_ddl_dnskey_vs_asn.in Makefile
	mkdir -p hedgehog/DDL_updates
	$(subst_LIBEXECDATA) < $(srcdir)/hedgehog/DDL_updates/000013_ddl_dnskey_vs_asn.in  | $(subst_DB_VERSION) > hedgehog/DDL_updates/000013_ddl_dnskey_vs_asn

hedgehog/DDL_updates/000014_ddl_service_addr: $(srcdir)/hedgehog/DDL_updates/000014_ddl_service_addr.in  Makefile
	mkdir -p hedgehog/DDL_updates
	$(subst_LIBEXECDATA) < $(srcdir)/hedgehog/DDL_updates/000014_ddl_service_addr.in | $(subst_DB_VERSION) > hedgehog/DDL_updates/000014_ddl_service_addr

hedgehog/DDL_updates/000015_ddl_byregion: $(srcdir)/hedgehog/DDL_updates/000015_ddl_byregion.in Makefile
	mkdir -p hedgehog/DDL_updates
	$(subst_LIBEXECDATA) < $(srcdir)/hedgehog/DDL_updates/000015_ddl_byregion.in | $(subst_DB_VERSION) > hedgehog/DDL_updates/000015_ddl_byregion

hedgehog/DDL_updates/000016_ddl_server_addr_vs_trans: $(srcdir)/hedgehog/DDL_updates/000016_ddl_server_addr_vs_trans.in Makefile
	mkdir -p hedgehog/DDL_updates
	$(subst_LIBEXECDATA) < $(srcdir)/hedgehog/DDL_updates/000016_ddl_server_addr_vs_trans.in | $(subst_DB_VERSION) > hedgehog/DDL_updates/000016_ddl_server_addr_vs_trans

hedgehog/DDL_updates/000017_ddl_node_stats: $(srcdir)/hedgehog/DDL_updates/000017_ddl_node_stats.in Makefile
	mkdir -p hedgehog/DDL_updates
	$(subst_LIBEXECDATA) < $(srcdir)/hedgehog/DDL_updates/000017_ddl_node_stats.in | $(subst_DB_VERSION) >hedgehog/DDL_updates/000017_ddl_node_stats

EXTRA_DIST = refile_and_grok.in \
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
             database_process_rssac_data.in \
             database_rm_old_rssac_data.in 

install-data-hook:
	mkdir -p ${DESTDIR}$(localstatedir)/hedgehog/data
	chmod -R 775 ${DESTDIR}$(localstatedir)/hedgehog/data


dist_man_MANS = hedgehogctl.1 \
                refile_and_grok.1 \
                hedgehog_database_create.1

hedgehogctl.1: hedgehogctl Makefile
	chmod 755 hedgehogctl
	$(HELP2MAN) -h help2man --version-string=@PACKAGE_VERSION@ -N -s 1 -n "Wrapper around hedgehog management scripts" ./hedgehogctl -o hedgehogctl.1
	
refile_and_grok.1: refile_and_grok Makefile
	chmod 755 refile_and_grok
	$(HELP2MAN) -h -h --version-string=@PACKAGE_VERSION@ -N -s 1 -n "Wrapper around the dsc-extractor application that launches multiple extractors to process data" ./refile_and_grok -o refile_and_grok.1

hedgehog_database_create.1: $(srcdir)/hedgehog/hedgehog_database_create Makefile
	$(HELP2MAN) -h -h --version-string=@PACKAGE_VERSION@ -N -s 1 -n "This script is to aid the database administrator with creating the hedgehog database." $(srcdir)/hedgehog/hedgehog_database_create -o hedgehog_database_create.1