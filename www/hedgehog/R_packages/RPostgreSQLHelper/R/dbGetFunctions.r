# 
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at https://mozilla.org/MPL/2.0/.
#

#
# Developed by Sinodun IT (www.sinodun.com)
#

#   wrapper functions for RPostgreSQL dbSendQuery and
#   fetch to handle db connection failures, where
#   connections are initialised via rapache config file.
#   
#   ensures that dbSendQuery first attempts to
#   reconnect to the database if the connection has been
#   lost (apache2 force-reload) and fails gracefully in
#   the event that the connection to the database cannot
#   be re-established.
#   
#   dbGetResultSet() will return a result set if successful
#   or NULL otherwise.
#   
#   dbGetDataFrame() will return a data frame if successful
#   or NULL otherwise.
#   
#   dependencies:   RPostgreSQL
#   
#   author: John Dickinson <jad@sinodun.com>


library("RPostgreSQL")

# max number of attempts to reconnect to the database
maxAttempts <- 3


#   attempt to re-establish a db connection
.reload <- function(dbiDriver, dbiConnection, dbConnStr){
    # close any pending result sets
    resSets = try(dbListResults(dbiConnection))
    if(class(resSets) != "try-error"){
        for(resultSet in resSets){
            dbClearResult(resultSet)
        }
    }

    # close all connections that the dbiDriver is managing
    conns = try(dbListConnections(dbiDriver))
    if(class(conns) != "try-error"){
        for(connection in conns){
            dbDisconnect(connection)
        }
    }

    dbiConnection <- eval(parse(text = paste("dbConnect(dbdrv,",  dbConnStr,")")))

}

#   return the result set associated with sqlQueryStr
#   from dbiConnection. If the dbiConnection has been lost,
#   attempt to reconnect to the db. If dbiConnection cannot
#   be established, return NULL
dbGetResultSet <- function(dbiDriver, dbiConnection, dbConnStr, sqlQueryStr){
    rs <- NULL
    for(attempt in 1:(maxAttempts+1)){
        rs <- try(dbSendQuery(dbiConnection ,sqlQueryStr))
        if(class(rs) == "try-error"){
            if(attempt == 1){
                system('logger -p user.notice Hedgehog: Error sending query to database')
            }
            if(attempt == (maxAttempts+1)){
                system('logger -p user.notice Hedgehog: Critical Giving up trying to send query to the database: administrator action required')
                rs <- NULL
            }else{
                system(paste("logger -p user.notice Hedgehog: Info re-connecting to the database: attempt ", attempt, " of ", maxAttempts, sep=""))
                .reload(dbiDriver, dbiConnection, dbConnStr)
            }
        }else break
    }
    return(rs)
}

#   return the data frame associated with sqlQueryStr
#   from dbiConnection. 
dbGetDataFrame <- function(dbiDriver, dbiConnection, dbConnStr, sqlQueryStr){
    df <- NULL
    rs <- dbGetResultSet(dbiDriver, dbiConnection, dbConnStr, sqlQueryStr)
    if(!is.null(rs)){
        df <- fetch(rs, n=-1)
    dbClearResult(rs)
    }
    return(df)
}