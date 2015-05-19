bin_PROGRAMS = dsc-extractor

dsc_extractor_SOURCES = dsc-extractor.cpp

dsc_extractor_CXXFLAGS = @LIBPQXX_INCLUDES@ @BOOST_CPPFLAGS@ -I$(top_srcdir)/src/libdsc

dsc_extractor_LDADD = @BOOST_SYSTEM_LDFLAGS@ \
                          @BOOST_SYSTEM_LIBS@ \
                          @BOOST_FILESYSTEM_LDFLAGS@ \
                          @BOOST_FILESYSTEM_LIBS@ \
                          @BOOST_PROGRAM_OPTIONS_LDFLAGS@ \
                          @BOOST_PROGRAM_OPTIONS_LIBS@ \
                          @LIBPQXX_LIBS@ \
                          ${top_builddir}/src/libdsc/libdsc.a
