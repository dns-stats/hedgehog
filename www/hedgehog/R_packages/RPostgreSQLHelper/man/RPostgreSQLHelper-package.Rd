%%
%% Copyright 2014 Internet Corporation for Assigned Names and Numbers.
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%% http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.
%%

%%
%% Developed by Sinodun IT (www.sinodun.com)
%%

\name{RPostgreSQLHelper-package}
\alias{RPostgreSQLHelper-package}
\alias{RPostgreSQLHelper}
\docType{package}
\title{RPostgreSQL wrapper functions}
\description{Handles dbiConnection failures}
\details{
\tabular{ll}{
Package: \tab RPostgreSQLHelper\cr
Type: \tab Package\cr
Version: \tab 1.0\cr
Date: \tab 2013-03-20\cr
License: \tab GPL-3\cr
}
dbSendQuery: dbGetResultSet(dbiDriver, dbiConnection, dbConnStr, sqlQueryStr)

dbSendQuery + fetch: dbGetDataFrame(dbiDriver, dbiConnection, dbConnStr, sqlQueryStr)
}
\author{John Dickinson <jad@sinodun.com>}
\references{
	https://code.google.com/p/rpostgresql/
	http://stat.bell-labs.com/RS-DBI/doc/html/index.html
}
%%~~ Optionally other standard keywords, one per line, from file KEYWORDS in ~~
%%~~ the R documentation directory ~~
\keyword{ package }
\seealso{
%%~~ Optional links to other man pages, e.g. ~~
%%~~ \code{\link[<pkg>:<pkg>-package]{<pkg>}} ~~
}
\examples{
%%~~ simple examples of the most important functions ~~
}
