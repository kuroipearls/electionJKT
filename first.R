#Include packages
library(twitteR)
library(RCurl)
library(RJSONIO)
library(stringr)

#Declare Twitter API Credentials
api_key <- "7ayJQc1GOOVHtRcDDAmdtUDoG" 
api_secret <- "jxPiYcprbdoQR48R3uikPUhI6YwuM5M2kDDGUPxCbqDWxxiqeZ"
token <- "161165077-N648ib8PTAWfV71uBIBsr1WaQhs2mGqN7ddnedtm"
token_secret <- "YAm6bNpfGFSjSokihzVlwGbZGAULmK1ziG4cVxg8SRVq1"

#Create Connection
setup_twitter_oauth(api_key, api_secret, token, token_secret)

#Twitter Search 
tweets <- searchTwitter("@sylviana_murni", n=5000, since='2017-01-03', until='2017-01-04')
#print(tweets)
no_retweets <- strip_retweets(tweets, strip_manual=TRUE, strip_mt=TRUE)
noretweets.df <- twListToDF(no_retweets)
write.csv(noretweets.df, "sylviana3jan.csv")

#Transfer tweets to data frame
tweets.df <- twListToDF(tweets)

#print(tweets.df)
write.csv(tweets.df, "cobart.csv")
