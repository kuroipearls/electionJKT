library(plyr)
library(ggplot2)
library(RColorBrewer)

train <- read.csv('anies1desC.csv', stringsAsFactors = F)

ggplot(train, aes(x=class)) +
  geom_bar(aes(y=..count.., fill=train$class)) +
  scale_fill_brewer(palette="RdGy") +
  labs(x="polarity categories", y="number of tweets") 
