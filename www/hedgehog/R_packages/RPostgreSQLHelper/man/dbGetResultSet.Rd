%%
%% Copyright 2014, 2015, 2016 Internet Corporation for Assigned Names and Numbers.
%%
%% This Source Code Form is subject to the terms of the Mozilla Public
%% License, v. 2.0. If a copy of the MPL was not distributed with this
%% file, you can obtain one at https://mozilla.org/MPL/2.0/.
%%
%% Developed by Sinodun IT (www.sinodun.com)
%%

\name{dbGetResultSet}
\alias{dbGetResultSet}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{RPostgreSQL dbSendQuery wrapper function}
\description{Handles dbiConnection failures}
\usage{
dbGetResultSet(dbiDriver, dbiConnection, dbConnStr, sqlQueryStr)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{dbiDriver}{
Database driver dbiDriver
}
  \item{dbiConnection}{
Database connection dbiConnection
}
  \item{dbConnStr}{
Database connection string dbConnStr
}
  \item{sqlQueryStr}{
String containing SQL query to be run
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{if successful, return a DBIResult else returns NULL}
\references{
	https://code.google.com/p/rpostgresql/
	http://stat.bell-labs.com/RS-DBI/doc/html/index.html
}
\author{John Dickinson <jad@sinodun.com>}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
