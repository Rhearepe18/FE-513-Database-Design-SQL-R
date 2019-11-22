# Exercise 1

#Vector

#Create two vectors for your first name and last name separately. 
a <- "Rhea"
b <- "Repe"

#Combine the two vectors
Details <- c(a,b)
Details

#Display data type of the vector
mode(Details)
typeof(Details)


#Append campus ID to the vector
Details <- append(Details, 10438997)  
#combining char with other type int one vector, the values are all treated like char
Details

#Transfer the vector to data frame. Set a name for each column/row.
Details <- as.data.frame(Details, row.names =c("Name", "Last name", "Campus ID"))
Details

#How missing values and impossible values are represented in R language
#In R, missing values are represented by the symbol NA (not available). 
#Impossible values (domain errors like division by 0 or log of negative numbers) are represented by the symbol NaN (Not-A-Number). 
#NA is used for both numeric and string data.


#Matrix

#Create a vector with 10 numbers.
vector <- 1:10
vector

#Transfer the above vector into matrix M with two columns.
m <- matrix(vector, nrow = 5, ncol = 2, byrow = F)
m

#Get transposed matrix M. Print the element in second row first column

M <- t(m)
M
#Print the element in second row first column
M[2,1]



#Two vectors X and Y are defined as follows - X=c(3,2,4)andY = c(1, 2). 
#What will be output of vector Z that is defined as Z = X*Y

X <- c(3, 2, 4)
Y <- c(1, 2)
Z <- X*Y  
Z


#Function

#What is the use of With () and By () function in R?
?with
#with(data, expr, ...)
#with is a generic function that evaluates expr in a local environment constructed from data. 
#The environment has the caller's environment as its parent. 
#This is useful for simplifying calls to modeling functions.
#(Note: if data is already an environment then this is used with its existing parent.)
#For with, the value of the evaluated expr

#example
with(mtcars, mpg[cyl == 8  &  disp > 350]) #only mention data set and column specifications
# is the same as, but nicer than
mtcars$mpg[mtcars$cyl == 8  &  mtcars$disp > 350] #complicated way for the same

#source: https://www.rdocumentation.org/packages/base/versions/3.5.1/topics/with


?by
#Function by is an object-oriented wrapper for tapply applied to data frames.
#by(data, INDICES, FUN, ..., simplify = TRUE)
#A data frame is split by row into data frames subsetted by the values of 
#one or more factors, and function FUN is applied to each subset in turn.
#The by( ) function applys a function to each level of a factor or factors
#data - an R object, normally a data frame, possibly a matrix.
#INDICES - a factor or a list of factors, each of length nrow(data).
#FUN - a function to be applied to (usually data-frame) subsets of data.


#An object of class "by", giving the results for each subset. 
#This is always a list if simplify is false, otherwise a list or array
#Example
by(warpbreaks[, 1:2], warpbreaks[,"tension"], summary)


#Exercise II
#Download 1-year daily stock price data into csv file and load it into R environment
#Calculate median, mean, standard deviation of log returns in R.
#Count how many days with log return between 0.01 and 0.015 in R.
#Plot the histogram of stock daily returns(use 20 bins).


#downloaded S&P 1-year daily stock prices
library(quantmod)
setwd("/Users/rhearepe/Downloads")
stocks <- read.csv("GSPC.csv", header = T)   #S&P 1- year data
stocks <- data.frame(stocks)

head(stocks)

#log returns
price <- stocks$Adj.Close
log_returns <- diff(log(stocks$Adj.Close))

#alternate way to find log returns(as shown in Intro to R class(FE515))
price.pt <- price[2:length(price)]
price.pt1 <- price[1: (length(price)-1) ]

log.return <- log(price.pt) - log(price.pt1)
head(log.return)

head(log_returns)
#Mean of log returns
mean(log_returns)

#Median of log returns
median(log_returns)


#Standard Deviation of log returns
sd(log_returns)

#Count how many days with log return between 0.01 and 0.015 

length(which(log_returns > 0.01 & log.return < 0.015))
#16 days

#Plot the histogram of stock daily returns(use 20 bins)
hist(log_returns, breaks = 20, 
     xlab = "Log daily returns",
     main = "histogram of S&P 500 daily returns",
     col = "yellow")

