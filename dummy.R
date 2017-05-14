#FOR FEATURE SELECTION - FISHER SCORE
require(plyr)
train <- read.csv('testingSetStem.csv', stringsAsFactors = F)
df <- read.csv('getAll.csv', stringsAsFactors = F)
tes <- 6:10
for(i in 1:5) {
  df <- subset(df, select = -c(colnames(df[i])))
}
df <- df[,-c(tes[1]:tes[2])]

getSub1 <- subset(df, is_kelas==1)
getCount1 <- sum(getSub1$rahim)
print(getCount1)
getSub_1 <- subset(df, is_kelas==-1)
getCount_1 <- sum(getSub_1$rahim)
print(getCount_1)
getSub0 <- subset(df, is_kelas==0)
getCount0 <- sum(getSub0$rahim)
print(getCount0)

train$is_kelas <- factor(train$is_kelas)
res <- count(train$is_kelas)
print(res)


x <- 1:4860
for(i in 1:4860) {
  if(sum(getSub1[[i]]) == sum(getSub_1[[i]])) {
    x[i] = (nrow(getSub0) * nrow(getSub_1)) / (nrow(getSub0) + nrow(getSub_1)) * 
      (mean(getSub0[[i]]) - mean(getSub_1[[i]])) * 
      ( mean(getSub0[[i]]) - mean(getSub_1[[i]])) / 
      (nrow(getSub0) * var(getSub0[[i]]) + nrow(getSub_1) * var(getSub_1[[i]]))
  } else if(sum(getSub1[[i]]) > sum(getSub_1[[i]])) {
    x[i] = ((nrow(getSub0) * nrow(getSub1)) / (nrow(getSub0) + nrow(getSub1)) * 
      (mean(getSub0[[i]]) - mean(getSub1[[i]])) * 
      ( mean(getSub0[[i]]) - mean(getSub1[[i]])) / 
      (nrow(getSub0) * var(getSub0[[i]]) + nrow(getSub1) * var(getSub1[[i]]))) + 
      ((nrow(getSub_1) * nrow(getSub1)) / (nrow(getSub_1) + nrow(getSub1)) * 
      (mean(getSub_1[[i]]) - mean(getSub1[[i]])) * 
      ( mean(getSub_1[[i]]) - mean(getSub1[[i]])) / 
      (nrow(getSub_1) * var(getSub_1[[i]]) + nrow(getSub1) * var(getSub1[[i]])))
  } else {
    x[i] = ((nrow(getSub0) * nrow(getSub_1)) / (nrow(getSub0) + nrow(getSub_1)) * 
      (mean(getSub0[[i]]) - mean(getSub_1[[i]])) * 
      ( mean(getSub0[[i]]) - mean(getSub_1[[i]])) / 
      (nrow(getSub0) * var(getSub0[[i]]) + nrow(getSub_1) * var(getSub_1[[i]]))) + 
      ((nrow(getSub_1) * nrow(getSub1)) / (nrow(getSub_1) + nrow(getSub1)) * 
      (mean(getSub_1[[i]]) - mean(getSub1[[i]])) * 
      ( mean(getSub_1[[i]]) - mean(getSub1[[i]])) / 
      (nrow(getSub_1) * var(getSub_1[[i]]) + nrow(getSub1) * var(getSub1[[i]])))
  }
}
print(x)
ind <- 1:4860
x[is.nan(x)] <- 0
finaldf <- data.frame(ind,x)
finaldf <- finaldf[ order(finaldf$x), ]
lwords <- colnames(df[finaldf[1:4860,1]]) 
#print(colnames(df[finaldf[1:10,1]]))
df <- df[ , !(names(df) %in% lwords)]
write.csv(df,"cobatestreduc2.csv")

#df <- df[,-c(ind[1]:ind[10])] --> to remove by index

write.csv(lwords,"rankwords.csv")
