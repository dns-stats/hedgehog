CLEANFILES = $(localstate_DATA) $(noinst_DATA)

sysconfdir = @sysconfdir@/hedgehog

nobase_sysconf_DATA = $(srcdir)/tlds.d/cctlds.csv \
                      $(srcdir)/tlds.d/idn_cctlds.csv \
                      $(srcdir)/tlds.d/legacy_gtlds.csv \
                      $(srcdir)/tlds.d/new_gtlds-20131023-20150611.csv \
                      $(srcdir)/tlds.d/new_gtlds-20150614-20151223.csv

noinst_DATA = hedgehog.yaml

hedgehog.yaml: $(srcdir)/hedgehog.yaml.in Makefile
	$(subst_HH_DIRS) < $(srcdir)/hedgehog.yaml.in > hedgehog.yaml

EXTRA_DIST = (srcdir)/hedgehog.yaml.in

install-data-hook:
	test -d ${DESTDIR}${sysconfdir} || mkdir -p ${DESTDIR}${sysconfdir}
	test -f ${DESTDIR}${sysconfdir}/hedgehog.yaml || \
		${INSTALL_DATA} -m 644 hedgehog.yaml ${DESTDIR}${sysconfdir}
	${INSTALL_DATA} -m 644 hedgehog.yaml ${DESTDIR}${sysconfdir}/hedgehog.yaml.sample
	test -f ${DESTDIR}${sysconfdir}/nodes.csv || \
		${INSTALL_DATA} -m 644 $(srcdir)/nodes.csv ${DESTDIR}${sysconfdir}
	test -f ${DESTDIR}${sysconfdir}/service_addr.csv || \
		${INSTALL_DATA} -m 644 $(srcdir)/service_addr.csv ${DESTDIR}${sysconfdir}
	${INSTALL_DATA} -m 644 $(srcdir)/nodes.csv ${DESTDIR}${sysconfdir}/nodes.csv.sample