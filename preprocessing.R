#THIS IS FOR COMBINING AND CLEANING DATASETS
require(dplyr)
require(stringr)
require(data.table)
require(tm)
require(Matrix)
require(e1071)
require(katadasaR)
words <- c("pelayan", "pemain", "pengendara", "pelaku", "pelajaran", "pemimpin")
words <- c("tangannya", "tandingannya", "penglihatannya", "pelakunya")
words <- c("Berada", "bermain", "beribadah", "berita")
sapply(words, katadasaR)

#read data
train <- read.csv('try_error.csv', stringsAsFactors = F)
new_train <- read.csv('train_set/lab_anies14des.csv', stringsAsFactors = F)
train <- rbind(train, new_train)

#change class to numeric
train$is_kelas = as.numeric(as.character(train$is_kelas))
write.csv(train,"trainingsetFIX.csv")

#change is_3 value = 1
train$is_3 <- 1    
#change tanggal value = 2016-12-01
train$tanggal <- as.Date(c("2016-12-01"))
#change NA sentimen_3 value with sentimen value
train$sentimen_3[is.na(train$sentimen_3)] <- as.integer(train$sentimen[is.na(train$sentimen_3)])
#change is_sentimen value with conditional statement
train$is_sentimen <- ifelse(train$sentimen==0, -1, 1)

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

#get duplicated tweets (one paslon)
count_duplicate <- which(duplicated(train$text))
#delete all duplicated tweets (one paslon)
train <- train[!duplicated(train$text),]
write.csv(train,"testingsetFIXX.csv")

#get and replace all original and duplicate tweets (for different paslon)
train$is_2[ duplicated(train$text) | duplicated(train$text, fromLast = TRUE) ] <- 1

# Create the corpus
MyCorpus <- VCorpus(VectorSource(train$text))
content(MyCorpus[[1]])

# Some preprocessing
MyCorpus <- tm_map(MyCorpus, content_transformer(tolower))
content(MyCorpus[[1]])

#remove stopwords 
MyCorpus <- tm_map(MyCorpus, removeWords, c("yang", "di", "ke", "dan", "yg", "ini",
                                            "itu", "saja", "dengan", "untuk", "dari",
                                            "juga", "lalu", "dalam", "akan", "pada",
                                            "karena", "tersebut", "bisa", "ada", 
                                            "krn", "tsb", "dgn", "dg", "utk", "jga",
                                            "dlm", "pd"))

aha<-data.frame(text=unlist(sapply(MyCorpus, `[`, "content")), 
                      stringsAsFactors=F)  #for testing set, re-arrange words
aha$is_kelas <- train$sentimen
write.csv(aha,"testingsetFIXX.csv")
  
# Create the Document-Term matrix
DTM <- DocumentTermMatrix(MyCorpus)
#DTM <- DocumentTermMatrix(MyCorpus, control = list(bounds = list(global = c(0, Inf)))) 
dim(DTM)
inspect(DTM)

#change DTM to a matrix, then to a data frame
adtm.m<-as.matrix(DTM)
adtm.df<-as.data.frame(adtm.m)
adtm.df$is_kelas = train$sentimen
adtm.df$is_kelas = as.numeric(as.character(adtm.df$is_kelas))
write.csv(adtm.df,"trainingsetFIXX.csv")

#for stemming
haha <- strsplit(train$text, " ")
print(haha)
for(i in 1:1) {
  hasil <- sapply(haha[[i]], katadasaR)
  train$text[[i]] <- paste(hasil, collapse=' ')
}
print(hasil)
write.csv(train,"checkanies4.csv")
