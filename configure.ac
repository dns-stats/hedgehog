# 
# Copyright 2014 Internet Corporation for Assigned Names and Numbers.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ(2.61)
AC_INIT(Hedgehog, 2.0.0a1, jad@sinodun.com)
AC_CONFIG_SRCDIR([src/libdsc/DSCDataManager.cpp])
AC_CONFIG_HEADER([config.h])

AC_DEFINE_UNQUOTED([DB_SCHEMA_VERSION],[6],[Database version])
AC_SUBST([DB_SCHEMA_VERSION],[6])

AC_CONFIG_MACRO_DIR([m4])

AM_INIT_AUTOMAKE([foreign])
m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])

# Checks for programs.
AC_PROG_CXX
AC_PROG_AWK
AC_PROG_CC
AC_PROG_CPP
AC_PROG_INSTALL
AC_PROG_LN_S
AC_PROG_MAKE_SET
AC_PROG_LIBTOOL
LT_INIT

# Checks for libraries.
# FIXME: Replace `main' with a function in `-lresolv':
AC_CHECK_LIB([resolv], [main])

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

AX_OPTIMIZER
AC_CONFIG_FILES(Makefile conf/Makefile src/bin/Makefile src/libdsc/Makefile tools/Makefile www/Makefile )
AC_OUTPUT
