# 
# Copyright 2014, 2015, 2016 Internet Corporation for Assigned Names and Numbers.
# 
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at https://mozilla.org/MPL/2.0/.

# Developed by Sinodun IT (www.sinodun.com)

AC_DEFUN([ACX_POSTGRES],[
	AC_ARG_WITH([postgres], 
		[AC_HELP_STRING([--with-postgres=PATH],[specify prefix of path of PostgreSQL])],
        	[
			POSTGRES_PATH="$withval"
		],[
			POSTGRES_PATH="/usr/local"
		])

        AC_ARG_WITH([postgres-includes], 
                [AC_HELP_STRING([--with-postgres-includes=PATH],[specify include prefix of PostgreSQL])],
                [
                        POSTGRES_INCLUDE_PATH="$withval"
                ],[
                        POSTGRES_INCLUDE_PATH="/usr/include"
                ])


	AC_MSG_CHECKING(what are the postgres includes)
	POSTGRES_INCLUDES="-I$POSTGRES_INCLUDE_PATH"
	AC_MSG_RESULT($POSTGRES_INCLUDES)

	AC_MSG_CHECKING(what are the postgres libs)
	POSTGRES_LIBS="-L$POSTGRES_PATH/lib64 -L$POSTGRES_PATH/lib -lpq"
	AC_MSG_RESULT($POSTGRES_LIBS)

	tmp_CFLAGS=$CFLAGS
	tmp_LIBS=$LIBS

	CFLAGS="$CFLAGS $POSTGRES_INCLUDES"
	LIBS="$LIBS $POSTGRES_LIBS"

	AC_CHECK_LIB(pq, PQconnectdb,,[AC_MSG_ERROR([Can't find PostgreSQL])])
	LIBS=$tmp_LIBS
	CFLAGS=$tmp_CFLAGS

	AC_SUBST(POSTGRES_INCLUDES)
	AC_SUBST(POSTGRES_LIBS)
])
