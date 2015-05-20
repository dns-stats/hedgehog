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

AC_DEFUN([ACX_COMPONENTS],
[
    AC_ARG_ENABLE([web],
                AS_HELP_STRING([--disable-web],
                [Dont build the web interface - enabled by default.]),
                [AS_IF([test "x$enableval" == "xno"], [WEB=0])])
                
    AC_ARG_ENABLE([importer],
                AS_HELP_STRING([--disable-importer],
                [Dont build the importer - enabled by default.]),
                [AS_IF([test "x$enableval" == "xno"], [IMPORTER=0])])

])