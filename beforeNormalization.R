#TO PREPARE NORMALIZATION
require(dplyr)
require(stringr)
require(data.table)
require(tm)
require(Matrix)
require(e1071)
require(katadasaR)
require(devtools)
require(qdapRegex)

train <- read.csv('cobacektrain.csv', stringsAsFactors = F)
new_train <- read.csv('cobatest.csv', stringsAsFactors = F)
train <- rbind(train, new_train)

# Create the corpus
MyCorpus <- VCorpus(VectorSource(train$text))

# Some preprocessing
MyCorpus <- tm_map(MyCorpus, content_transformer(tolower))
DTM <- DocumentTermMatrix(MyCorpus)
adtm.m<-as.matrix(DTM)
adtm.df<-as.data.frame(adtm.m)
write.csv(colnames(adtm.df),"listwords.csv")
adtm.df$is_kelas = train$is_kelas
write.csv(adtm.df,"getAll.csv")

