#THIS IS FOR PREPROCESS TRAINING DATA WITHOUT STEMMING & NORMAL DTM
require(dplyr)
require(stringr)
require(data.table)
require(tm)
require(Matrix)
require(e1071)
require(katadasaR)

train <- read.csv('train_set.csv', stringsAsFactors = F)

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
train$text = tolower(train$text)

#delete all duplicated tweets (one paslon)
train <- train[!duplicated(train$text),]

# Create the corpus
MyCorpus <- VCorpus(VectorSource(train$text))

# Some preprocessing
MyCorpus <- tm_map(MyCorpus, content_transformer(tolower))

#remove stopwords 
MyCorpus <- tm_map(MyCorpus, removeWords, c("yang", "di", "ke", "dan", "yg", "ini",
                                            "itu", "saja", "dengan", "untuk", "dari",
                                            "juga", "lalu", "dalam", "akan", "pada",
                                            "karena", "tersebut", "bisa", "ada", 
                                            "krn", "tsb", "dgn", "dg", "utk", "jga",
                                            "dlm", "pd"))

# Create the Document-Term matrix
DTM <- DocumentTermMatrix(MyCorpus)

#change DTM to a matrix, then to a data frame
adtm.m<-as.matrix(DTM)
adtm.df<-as.data.frame(adtm.m)
adtm.df$is_kelas = train$sentimen
adtm.df$is_kelas = as.numeric(as.character(adtm.df$is_kelas))

write.csv(adtm.df,"trainingSetNormalNoStem.csv")