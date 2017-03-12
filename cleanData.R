#Include packages
library(twitteR)
library(RCurl)
library(RJSONIO)
library(stringr)
library(tm)
library(SnowballC)
library(FactoMineR)
library(wordcloud)


#Declare Twitter API Credentials
api_key <- "7ayJQc1GOOVHtRcDDAmdtUDoG" 
api_secret <- "jxPiYcprbdoQR48R3uikPUhI6YwuM5M2kDDGUPxCbqDWxxiqeZ"
token <- "161165077-N648ib8PTAWfV71uBIBsr1WaQhs2mGqN7ddnedtm"
token_secret <- "YAm6bNpfGFSjSokihzVlwGbZGAULmK1ziG4cVxg8SRVq1"

#Create Connection
setup_twitter_oauth(api_key, api_secret, token, token_secret)
train <- read.csv('lab_anies1des.csv', stringsAsFactors = F)
print(train)
txt = train$text
str(train)


txt <- searchTwitter("@AgusYudhoyono", n=500, since='2016-12-01', until='2016-12-02')
clean <- sapply(txt, function(x) x$getText())

txt <- twListToDF(txt)

# remove retweet & via 
clean = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", txt)
# remove Atpeople
clean = gsub("@\\w+", "", clean)
# remove punctuation symbols
clean = gsub("[[:punct:]]", "", clean)
# remove numbers
clean = gsub("[[:digit:]]", "", clean)
# remove links
clean = gsub("http\\w+", "", clean)

# corpus
corpus = Corpus(VectorSource(clean))
corpus <- tm_map(corpus,content_transformer(function(x) iconv(x, to='UTF-8', sub='byte')),mc.cores=1)

corpus <- tm_map(corpus, content_transformer(tolower)) 
corpus <- tm_map(corpus, removePunctuation)
# convert to lower case
corpus <- tm_map(corpus, tolower)
# remove extra white-spaces
corpus = tm_map(corpus, stripWhitespace)

str(corpus)
# try fix
corpus <- tm_map(corpus, PlainTextDocument)
#corpus <- iconv(corpus,to="utf-8-mac")
#corpus <- Corpus(VectorSource(corpus))
# term-document matrix

convTweets <- iconv(corpus, to = "utf-8")
tweetsCorpus <- (convTweets[!is.na(convTweets)])
corpus = Corpus(VectorSource(tweetsCorpus))
print(convTweets)

tdm <- TermDocumentMatrix(corpus)


# convert as matrix
m = as.matrix(tdm)

# remove sparse terms (word frequency > 90% percentile)
wf = rowSums(m)
m1 = m[wf>quantile(wf,probs=0.9), ]

# remove columns with all zeros
m1 = m1[,colSums(m1)!=0]

# for convenience, every matrix entry must be binary (0 or 1)
m1[m1 > 1] = 1

# distance matrix with binary distance
m1dist = dist(m1, method="binary")

# cluster with ward method
clus1 = hclust(m1dist, method="ward")

# plot dendrogram
plot(clus1, cex=0.7)

str(m1)
# correspondance analysis
rei_ca = CA(m1, graph=FALSE)

# default plot of words
plot(rei_ca$row$coord, type="n", xaxt="n", yaxt="n", xlab="", ylab="")
text(rei_ca$row$coord[,1], rei_ca$row$coord[,2], labels=rownames(m1),col=hsv(0,0,0.6,0.5))
title(main="@REI Correspondence Analysis of tweet words", cex.main=1)

#this is another example (STARTS HERE)
m <- as.matrix(tdm)
word_freqs <- sort(rowSums(m), decreasing = TRUE)

# create the data frame with the words and their frequencies
dm <- data.frame(word = names(word_freqs), freq = word_freqs)
wordcloud(dm$word, dm$freq, random.order = FALSE , colors = brewer.pal(8,"Dark2"))
#ENDS HERE

train$text <- clean
lalala <- train [!duplicated(train$text),]
print(lalala)
write.csv(lalala,"tryclean_anies.csv")
