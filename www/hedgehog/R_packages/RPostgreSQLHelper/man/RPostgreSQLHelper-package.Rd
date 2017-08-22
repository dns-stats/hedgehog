%%
%% Copyright 2014, 2015, 2016 Internet Corporation for Assigned Names and Numbers.
%%
%% This Source Code Form is subject to the terms of the Mozilla Public
%% License, v. 2.0. If a copy of the MPL was not distributed with this
%% file, you can obtain one at https://mozilla.org/MPL/2.0/.

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
