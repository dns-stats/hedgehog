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
