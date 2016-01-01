CLEANFILES = $(localstate_DATA) $(noinst_DATA)

sysconfdir = @sysconfdir@/hedgehog

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
	test -d ${DESTDIR}${sysconfdir}/tlds.d || mkdir -p ${DESTDIR}${sysconfdir}/tlds.d
	test -f ${DESTDIR}${sysconfdir}/tlds.d/cctlds.csv || \
		${INSTALL_DATA} -m 644 $(srcdir)/tlds.d/cctlds.csv ${DESTDIR}${sysconfdir}/tlds.d/cctlds.csv
	test -f ${DESTDIR}${sysconfdir}/tlds.d/idn_cctlds.csv || \
		${INSTALL_DATA} -m 644 $(srcdir)/tlds.d/idn_cctlds.csv ${DESTDIR}${sysconfdir}/tlds.d/idn_cctlds.csv
	test -f ${DESTDIR}${sysconfdir}/tlds.d/legacy_glds.csv || \
		${INSTALL_DATA} -m 644 $(srcdir)/tlds.d/legacy_gtlds.csv ${DESTDIR}${sysconfdir}/tlds.d/legacy_gtlds.csv
	test -f ${DESTDIR}${sysconfdir}/tlds.d/new_gtlds.csv || \
		${INSTALL_DATA} -m 644 $(srcdir)/tlds.d/new_gtlds.csv ${DESTDIR}${sysconfdir}/tlds.d/new_gtlds.csv
	test -f ${DESTDIR}${sysconfdir}/tlds.d/more_gtlds.csv || \
		${INSTALL_DATA} -m 644 $(srcdir)/tlds.d/more_gtlds.csv ${DESTDIR}${sysconfdir}/tlds.d/more_gtlds.csv