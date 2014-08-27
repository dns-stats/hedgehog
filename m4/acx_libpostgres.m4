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
