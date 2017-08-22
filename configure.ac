# 
# Copyright 2014, 2015, 2016 Internet Corporation for Assigned Names and Numbers.
# 
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at https://mozilla.org/MPL/2.0/.
#

#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ(2.61)
AC_INIT(Hedgehog, 2.4.0,  dns-stats-users@dns-stats.org)
AC_CONFIG_SRCDIR([tools/hedgehogctl.in])
AC_CONFIG_HEADER([config.h])

AC_DEFINE_UNQUOTED([DB_SCHEMA_VERSION],[14],[Database version])
AC_SUBST([DB_SCHEMA_VERSION],[14])
AC_SUBST([VERSION_NAME],[Bare-bellied])

AC_CONFIG_MACRO_DIR([m4])

AM_INIT_AUTOMAKE([foreign])
m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])

# Checks for programs.
AC_PROG_CC
AC_PROG_CPP
AC_PROG_CXX
AC_PROG_AWK
AC_PROG_SED
AC_PROG_MAKE_SET
AC_PROG_INSTALL
AC_PROG_LN_S
AC_PROG_LIBTOOL
LT_INIT
AM_PATH_PYTHON
AC_PATH_PROG(HELP2MAN, help2man)
if test -z "$HELP2MAN"
then
  AC_MSG_ERROR("help2man not found")
fi

AC_CONFIG_FILES(Makefile conf/Makefile tools/Makefile)

WEB=1
DM=1
ACX_COMPONENTS
AS_IF([test $WEB -eq 1],[AC_MSG_NOTICE([Building Web Component...])
  AC_CONFIG_FILES(www/Makefile)

],[AC_MSG_NOTICE([Not building Web Component...])])

AS_IF([test $DM -eq 1],[AC_MSG_NOTICE([Building Data Manager Component...])

  # Checks for header files.
  AC_CHECK_HEADERS([arpa/inet.h fcntl.h netinet/in.h stdlib.h string.h sys/param.h unistd.h])

  # Checks for typedefs, structures, and compiler characteristics.
  AC_C_CONST
  AC_STRUCT_TM
  AC_TYPE_INT16_T
  AC_TYPE_INT32_T
  AC_TYPE_INT64_T
  AC_TYPE_INT8_T
  AC_TYPE_PID_T
  AC_TYPE_SIZE_T
  AC_TYPE_UINT16_T
  AC_TYPE_UINT32_T
  AC_TYPE_UINT64_T
  AC_TYPE_UINT8_T
  # Checks for library functions.
  AC_FUNC_STRFTIME
  AC_FUNC_MALLOC
  AC_FUNC_MKTIME
  AC_FUNC_REALLOC
  AC_CHECK_FUNCS([gettimeofday mempcpy memset strerror])

  BOOST_REQUIRE([1.41.0])
  BOOST_SYSTEM
  BOOST_FILESYSTEM
  BOOST_PROGRAM_OPTIONS
  BOOST_CONVERSION
  BOOST_UNORDERED
  BOOST_FOREACH
  BOOST_STRING_ALGO
  BOOST_TOKENIZER
  
  # Checks for libraries.
  ACX_POSTGRES
  ACX_LIBPQXX

  CXXFLAGS="${CXXFLAGS} -Wall -pedantic \
           -pedantic-errors -Wextra"

  AC_CONFIG_FILES(src/Makefile)
  
],[AC_MSG_NOTICE([Not building Data Manager Component...])])

AM_CONDITIONAL([DM], [test $DM -eq 1])
AM_CONDITIONAL([WEB], [test $WEB -eq 1])

AC_OUTPUT
