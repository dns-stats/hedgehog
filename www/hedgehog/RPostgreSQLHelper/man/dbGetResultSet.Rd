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
