#TO PREPARE SVM CLASSIFICATION
require(dplyr)
require(stringr)
require(data.table)
require(tm)
require(Matrix)
require(e1071)
require(katadasaR)
require(devtools)
require(qdapRegex)

train <- read.csv('ahokDesFIX.csv', stringsAsFactors = F)
new_train <- read.csv('test_set.csv', stringsAsFactors = F)
train <- rbind(train, new_train)

# remove links
#train$text = gsub("http\\w+", "", train$text)
train$text= rm_url(train$text, pattern=pastex("@rm_twitter_url", "@rm_url"))
train$text = gsub("&amp", " ", train$text)
# remove retweet & via 
train$text = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", " ", train$text)
# remove Atpeople
train$text = gsub("@\\w+", " ", train$text)
#remove hashtags
train$text <- str_replace_all(train$text,"#[a-z,A-Z]*"," ")
# remove punctuation symbols
train$text = gsub("[[:punct:]]", " ", train$text)
# remove numbers
train$text = gsub("[[:digit:]]", "", train$text)

#remove extra white-space in front (?)
train$text = gsub("^\\s+|\\s+$", " ", train$text) 
#remove all non-ASCII characters
train$text = iconv(train$text, "latin1", "ASCII", sub="")
#remove extra white-space
train$text = gsub("\\s+"," ",train$text)
train$text = gsub("[[:space:]]*$","",train$text)
train$text = tolower(train$text)
train$text = trimws(train$text)
write.csv(train,"checkAhokDes.csv")

#delete all duplicated tweets (one paslon)
train <- train[!duplicated(train$text),]

#for stemming
haha <- strsplit(train$text, " ")
for(i in 1:9071) {
  hasil <- sapply(haha[[i]], katadasaR)
  train$text[[i]] <- paste(hasil, collapse=' ')
}

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

#re-arrange words for testing set
aha<-data.frame(text=unlist(sapply(MyCorpus, `[`, "content")), 
                stringsAsFactors=F)  #for testing set, re-arrange words
aha$is_kelas <- train$sentimen
aha$text <- trimws(aha$text)
aha$text = gsub("\\s+"," ",train$text)
aha$text = gsub("[[:space:]]*$","",train$text)
write.csv(aha,"checkAniesDes.csv")

aha <- read.csv('checkAniesDes.csv', stringsAsFactors = F)
aha$is_kelas <- as.factor(aha$is_kelas)
getSub1 <- subset(aha, is_kelas==1)
getSub_1 <- subset(aha, is_kelas==-1)
getSub0 <- subset(aha, is_kelas==0)

testDF <- getSub1[1:10,1:2]
testDF <- rbind(getSub1[1:200,1:2], getSub_1[1:100,1:2])
testDF <- rbind(testDF, getSub0[1:500,1:2])
write.csv(testDF,"cobatest.csv")

trainDF <- rbind(getSub1, getSub_1)
trainDF <- rbind(trainDF, getSub0)
cektrainDF <- trainDF[-c(1:200, 869:968, 1256:1755), ]
write.csv(cektrainDF,"cobacektrain.csv")

MyCorpus <- VCorpus(VectorSource(trainDF$text))
DTM <- DocumentTermMatrix(MyCorpus)
adtm.m<-as.matrix(DTM)
adtm.df<-as.data.frame(adtm.m)
adtm.df$is_kelas = trainDF$is_kelas
adtm.df$is_kelas = as.numeric(as.character(adtm.df$is_kelas))
cpdf <- adtm.df

cpdf <- cpdf[-c(1:200, 869:968, 1256:1755), ]
write.csv(cpdf,"coba_train.csv")
