
#FE 513 Homeowrk 3

#Question 1
#Exercise I - API
#Download data about NASA from Twitter. 
#Clean the data

rm(list = ls())
#Packages
library(twitteR)
library(tm)
library(wordcloud)
library(SnowballC)



consumer_key<-"IRfCFGdHnxE0Bc2pLenJncorx"
consumer_secret<-"RN1zmkb9Gz4Ml7BNEweOEAurim1dRRI1VoksHNxEpBqz3jg0XC"
access_token<-"1162983084-5sDjT9nPOINxRT2O2ktgx4VnWAuID93u6OF3TDe"
access_secret<-"qmCiOHHB7ueSrWOwzqEelIUO7R3a3bLfPzLOuK6dF5Ii3"

setup_twitter_oauth(consumer_key,
                    consumer_secret,
                    access_token,
                    access_secret)

tweets <- userTimeline("NASA", n = 100)

tweets_df <- twListToDF(tweets)# convert tweets to a data frame

for (i in c(1:2, 20)) {
  cat(paste0("[", i, "]"))
  writeLines((strwrap(tweets_df$text[i], 60)))
}
# build a corpus, and specify the source to be character vectors
my_Corpus_x <- Corpus(VectorSource(tweets_df$text))

delete_URL <- function(x) gsub("http[^[:space:]]*", "", x)
gsub("[[:space:]]","","a      
     b       c")
# tm_map(corpus, function) is included in tm package
# it's an interface to apply transformation functions to corpors.
# convert to lower case
my_Corpus_x <- tm_map(my_Corpus_x, content_transformer(delete_URL))


remove_Number_Pun <- function(x) gsub("[^[:alpha:][:space:]]*", "", x)
my_Corpus_x <- tm_map(my_Corpus_x, content_transformer(remove_Number_Pun))
my_Corpus_x <- tm_map(my_Corpus_x, removePunctuation)
my_Corpus_x <- tm_map(my_Corpus_x, removeNumbers)
my_Corpus_x <- tm_map(my_Corpus_x, content_transformer(tolower))



Stop_words <- c(stopwords('english'), "available")

# available stopword lists are catalan, romanian, SMART
# remove "r" and "big" from stopwords

Stop_words <- setdiff(Stop_words, c("r", "big"))

my_Corpus_x <- tm_map(my_Corpus_x, removeWords, Stop_words)
my_Corpus_x <- tm_map(my_Corpus_x, stripWhitespace)
my_Corpus_x <- tm_map(my_Corpus_x, stemDocument)

#Question 2 - Text Mining
#• Use data from Exercise I. 
#Plot cloud word

#• Use topic modeling as described in Chapter 6 to model each document (description field) 
#as a mixture of topics and each topic as a mixture of words.
#• Do K-means cluster analysis. 
#Find out best K before using k-means cluster analysis, please give explanation how you choose K.

library(wordcloud)

my_Corpus_x
tdm <- TermDocumentMatrix(my_Corpus_x,control =list(wordLengths = c(1, Inf)))
tdm

matrix <- as.matrix(tdm)

data_Matrix = data.frame(matrix)


# calculate the frequency of words and sort it by frequency
word_freq <- sort(rowSums(data_Matrix), decreasing = T)

# plot word cloud
wordcloud(words = names(word_freq), freq = word_freq, min.freq = 2,
          random.order = F, colors = rainbow(75))




tdm2 <- removeSparseTerms(tdm, sparse = 0.95)
matrix_2 <- as.matrix(tdm2)
m3 <- t(matrix_2) # transpose the matrix to cluster documents

library(topicmodels)

dtm <- as.DocumentTermMatrix(tdm)

lda_1 <- LDA(dtm, k = 9)

term_1 <- terms(lda_1, 5) # first 5 terms of every topic

term_1 <- apply(term_1, MARGIN = 2, paste, collapse = ", ")

# first topic identified for every document (tweet)
topic_1 <- topics(lda_1, 1)

topics <- data.frame(date=as.Date(tweets_df$created), topic_1)

qplot(date, ..count.. , data=topics, geom="density", fill=term_1[topic_1], position="stack")

k <- 6 # number of clusters

kmeansResult <- kmeans(m3, k) # Perform k-means clustering on a data matrix
kmeansResult$cluster# A vector of integers (from 1:k) indicating the cluster to which each point is allocated
round(kmeansResult$centers, digits = 3) # cluster centers
for (i in 1:k){
  cat(paste("cluster ", i, ": ", sep = ""))
  s <- sort(kmeansResult$centers[i, ], decreasing = T)
  cat(names(s), "\n")
  # print the tweets of every cluster
  # print(tweets[which(kmeansResult$cluster==i)])
}

# choose K 
cost_df <- data.frame()#accumulator for cost results
#run kmeans for all clusters up to 50
for(i in 1:50){
  #Run kmeans for each level of i, allowing up to 20 iterations for convergence
  kmeans<- kmeans(x=tdm, centers=i, iter.max=20)
  #Combine cluster number and cost together, write to df
  cost_df<- rbind(cost_df, cbind(i, kmeans$tot.withinss))# tot.withiness: Total within-cluster sum of squares
}

names(cost_df) <- c("cluster", "cost")

#Cost plot

ggplot(data=cost_df, aes(x=cluster, y=cost, group=1)) + 
  geom_line(colour = "darkgreen") +
  theme(text = element_text(size=20)) +
  ggtitle("Reduction In Cost For Values of 'k'\n") +
  xlab("\nClusters") + 
  ylab("Within-Cluster Sum of Squares\n") +
  scale_x_continuous(breaks=seq(from=0, to=50, by= 10))
# The plot above is known as the 'elbow method', 
# where we get breakpoints in our cost plot to understand where we should of adding clusters. 
# The slope of the cost function gets lower at 2 clusters, then flatter again around 20 clusters. 
# This means that as we add clusters above 2 (or 20), 
# each additional cluster becomes less effective at reducing the distance from the each data center 


#Question 3


#Download GOOG stock price through R API over past 10 years
library(quantmod)
google <- getSymbols("GOOG", auto.assign = F, src = "yahoo", from = "2009-01-11")

head(google)

#Use the ses function from the forecast package to get a forecast based on simple exponential smoothing 
#for the next 12 months, and plot the forecast.

library(forecast)

forecast_1 <- ses(y = google$GOOG.Adjusted, h = 365)

plot(forecast_1, col = "red")

#Estimate an exponential smoothing model using the ets function with default parameters. 
#Then pass the model as input to the forecast function to get a forecast for the next 12 months, 
#and plot the forecast (both functions are from the forecast package).


forecast_2 = ets(y = google$GOOG.Adjusted)
plot(forecast(forecast_2, h = 365), col = "dark blue")

#Print a summary of the model estimated in the previous exercise, and 
#find the automatically estimated structure of the model. Does it include trend and 
#seasonal components? If those components are present are they additive or multiplicative?


summary(forecast_2)

plot(forecast_2, col = "purple")


#Thus from the summary of the model, we can conclude that it does contains a trend as well 
#as in its special components. However, we can see that over the period of time the graph is 
#increasing exponentially,though the plot might have some downfalls as well at sometimes, 
#but evetually when we compare the begining point with the last point,we see that the trend is 
#exponential(increasing over a period of time).
#since all the components are present, it can be said that the model is mltiplicative.

#Find a function in the forecast package that estimates the 
#BATS model (exponential smoothing state space model with Box-Cox transformation, ARMA errors, 
#trend and seasonal components). Use it to estimate the model with a damped trend, and make a forecast. 
#Plot the forecast.
g <- data.frame(google)
model <- bats(g$GOOG.Adjusted)
#bats_fit_1 = bats(google$GOOG.Adjusted, use.box.cox = NULL, 
#use.trend = NULL, use.damped.trend = TRUE, seasonal.periods = NULL, 
#use.arma.errors = TRUE, use.parallel = length(y) > 1000, num.cores = 2,
#bc.lower = 0, bc.upper = 1, biasadj = TRUE)

forecast(model)


plot(forecast(model),col = "blue")




