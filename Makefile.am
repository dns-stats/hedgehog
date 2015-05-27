ACLOCAL_AMFLAGS = -I m4

if IMPORTER
IMP = src
else
IMP =
endif

if WEB
W = www
else
W =
endif

SUBDIRS = conf tools $(W) $(IMP)

MAINTAINERCLEANFILES = $(srcdir)/Makefile.in

hh_web_conf_dir    = hedgehog/conf
hh_web_source_dir  = hedgehog/www
hh_data_dir        = hedgehog/data
hh_plotcache_dir   = hedgehog/www/plotcache
hh_rssac_dir       = hedgehog/www/rssac
hh_conf_dir        = hedgehog
hh_conf_file       = hedgehog.yaml

# Used to substitute into the hedgehog.yaml conf file and the hedgehog.conf file
subst_HH_DIRS = sed -e "s|@HH_WEB_CONF@|@datadir@/$(hh_web_conf_dir)|" \
					-e "s|@HH_WEB_SOURCE@|@datadir@/$(hh_web_source_dir)|" \
					-e "s|@HH_DATA_DIR@|@localstatedir@/$(hh_data_dir)|" \
					-e "s|@HH_PLOTCACHE@|@localstatedir@/$(hh_plotcache_dir)|" \
					-e "s|@HH_CONF@|@sysconfdir@/$(hh_conf_dir)|" \
					-e "s|@HH_RSSAC@|@localstatedir@/$(hh_rssac_dir)|"

#Used to substitute into startupR.in and hedgeghog_conf_read.sh
subst_HH_CONF_FILE = sed -e "s|@HH_CONF_FILE@|@sysconfdir@/$(hh_conf_dir)/$(hh_conf_file)|" 

export subst_HH_DIRS
export subst_HH_CONF_FILE
export hh_web_conf_dir
