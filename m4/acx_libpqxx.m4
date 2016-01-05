# 
# Copyright 2014, 2015, 2016 Internet Corporation for Assigned Names and Numbers.
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

AC_DEFUN([ACX_LIBPQXX],[
	AC_ARG_WITH([libpqxx], 
		[AC_HELP_STRING([--with-libpqxx=PATH],[specify prefix of path of libpqxx])],
      	[
			LIBPQXX_PATH="$withval"
		],[
			LIBPQXX_PATH="/usr/local"
		])

	AC_MSG_CHECKING(what are the libpqxx includes)
	LIBPQXX_INCLUDES="-I$LIBPQXX_PATH/include"
	AC_MSG_RESULT($LIBPQXX_INCLUDES)

	AC_MSG_CHECKING(what are the libpqxx libs)
	LIBPQXX_LIBS="-L$LIBPQXX_PATH/lib64 -L$LIBPQXX_PATH/lib -lpqxx"
	AC_MSG_RESULT($LIBPQXX_LIBS)

        tmp_CFLAGS=$CFLAGS
        tmp_CXXFLAGS=$CXXFLAGS
	tmp_LIBS=$LIBS

	CFLAGS="$CFLAGS $LIBPQXX_INCLUDES"
	CXXFLAGS="$CXXFLAGS $LIBPQXX_INCLUDES"
	LIBS="$LIBS $LIBPQXX_LIBS"

	AC_LANG(C++)
        AC_LINK_IFELSE(
                [AC_LANG_PROGRAM([#include "pqxx/pqxx"],
                  [pqxx::connection db_conn; pqxx::work db_trans( db_conn ); pqxx::pipeline db_pipe(db_trans)])],
                  ,
                  [AC_MSG_ERROR([Can't find libpqxx])])

	LIBS=$tmp_LIBS
	CFLAGS=$tmp_CFLAGS
        CXXFLAGS=$tmp_CXXFLAGS

	AC_SUBST(LIBPQXX_INCLUDES)
	AC_SUBST(LIBPQXX_LIBS)
])
