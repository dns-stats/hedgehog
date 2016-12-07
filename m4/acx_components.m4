# 
# Copyright 2014, 2015, 2016 Internet Corporation for Assigned Names and Numbers.
# 
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at https://mozilla.org/MPL/2.0/.

# Developed by Sinodun IT (www.sinodun.com)

AC_DEFUN([ACX_COMPONENTS],
[
    AC_ARG_ENABLE([web],
                AS_HELP_STRING([--disable-web],
                [Don't build the web interface - enabled by default.]),
                [AS_IF([test "x$enableval" == "xno"], [WEB=0])])
                
    AC_ARG_ENABLE([data-manager],
                AS_HELP_STRING([--disable-data-manager],
                [Don't build the data manager - enabled by default.]),
                [AS_IF([test "x$enableval" == "xno"], [DM=0])])

])