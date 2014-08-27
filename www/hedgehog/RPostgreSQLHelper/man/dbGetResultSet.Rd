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
dbGetResultSet(dbiDriver, dbiConnection, sqlQueryString)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{dbiDrivNmStr}{
String name of the dbiDriver
}
  \item{dbiConNmStr}{
String name of the dbiConnection
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
\author{Elena Simpson <elly@sinodun.com>}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (dbiDriver, dbiConnection, sqlQueryString) 
{
    rs <- NULL
    for (attempt in 1:2) {
        rs <- dbSendQuery(dbiConnection, sqlQueryString)
        if (is.null(rs)) {
            if (attempt > 1) {
                system("logger -p user.crit apache2 failed to reconnect to db: administrator action required")
            }
            else {
                system("logger -p user.notice database connection lost")
                for (resultSet in dbListResults(dbiConnection)) {
                  dbClearResult(resultSet)
                }
                for (connection in dbListConnections(dbiDriver)) {
                  dbDisconnect(connection)
                }
                dbUnloadDriver(dbDriver)
                .reload()
            }
        }
        else break
    }
    return(rs)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
