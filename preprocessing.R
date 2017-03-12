#THIS IS FOR COMBINING AND CLEANING DATASETS
require(dplyr)
require(stringr)
require(data.table)
require(tm)

#read data
train <- read.csv('checkanies.csv', stringsAsFactors = F) 

#change is_3 value = 1
train$is_3 <- 1    
#change tanggal value = 2016-12-01
train$tanggal <- as.Date(c("2016-12-01"))
#change NA sentimen_3 value with sentimen value
train$sentimen_3[is.na(train$sentimen_3)] <- as.integer(train$sentimen[is.na(train$sentimen_3)])

train$text = gsub("&amp", "", train$text)
# remove retweet & via 
train$text = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", train$text)
# remove Atpeople
train$text = gsub("@\\w+", "", train$text)
#remove hashtags
train$text <- str_replace_all(train$text,"#[a-z,A-Z]*","")
# remove punctuation symbols
train$text = gsub("[[:punct:]]", "", train$text)
# remove numbers
train$text = gsub("[[:digit:]]", "", train$text)
# remove links
train$text = gsub("http\\w+", "", train$text)
#remove extra white-space in front (?)
train$text = gsub("^\\s+|\\s+$", "", train$text) 
#remove all non-ASCII characters
train$text = iconv(train$text, "latin1", "ASCII", sub="")
#remove extra white-space
train$text = gsub("\\s+"," ",train$text)
train$text = gsub("[[:space:]]*$","",train$text)

#get duplicated tweets (one paslon)
count_duplicate <- which(duplicated(train$text))
#delete all duplicated tweets (one paslon)
train <- train[!duplicated(train$text),]

#get and replace all original and duplicate tweets (for different paslon)
train$is_2[ duplicated(train$text) | duplicated(train$text, fromLast = TRUE) ] <- 1

# Create the corpus
MyCorpus <- VCorpus(VectorSource(train$text))
content(MyCorpus[[1]])

# Some preprocessing
MyCorpus <- tm_map(MyCorpus, content_transformer(tolower))
content(MyCorpus[[1]])

# Create the Document-Term matrix
DTM <- DocumentTermMatrix(MyCorpus, 
                          control = list(bounds = list(global = c(0, Inf)))) 
dim(DTM)
inspect(DTM)

write.csv(train,"checkanies2.csv")
