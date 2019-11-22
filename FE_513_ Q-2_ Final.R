library(quantmod)
library(dplyr)
library(tidyr)

setwd("C:/Users/Neel Shah/Desktop/FE 513")

function_1 <- function(ticker, interval) { 
  TSLA <- getSymbols(ticker, from = "2017-1-4", to = "2018-1-4", 
                       auto.assign = F)
  TSLA <- as.data.frame(TSLA) 
  TSLA$date <- as.Date(row.names(TSLA))
  row.names(TSLA) <- seq(1, nrow(TSLA)) 
  TSLA <- TSLA[, c(7, 6)] 
  data <- TSLA$TSLA.Adjusted 
  origData <- as.data.frame(do.call(rbind, lapply(unname(split(data,
                                                               ceiling(seq_along(data)/interval))),
    function(x) { if (NROW(x) == interval) {
      return(x) 
      } else return(c(x, rep(NA, interval - NROW(x))))
 })))

   return(list(origData = origData))
}

TSLA_x <- function_1("TSLA", 10)

TSLA_x$origData
