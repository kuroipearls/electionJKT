#PERCOBAAN 1 - netral vs not netral
traine <- read.csv('trainNormalSVM.csv', stringsAsFactors = F)
new_train <- read.csv('testNormalSVM.csv', stringsAsFactors = F)
train <- rbind(traine, new_train)
#IF NETRAL (0) == 1, NOT_NETRAL (1/-1) == 0
train$is_kelas <- ifelse(train$is_kelas==0, 1, 0)
getnetral <- subset(train, is_kelas==1)
get_netral <- subset(train, is_kelas==0)
#perbandingan 1 : 1,5 --> 500 : 750 (-netral : netral) ||| Asli : 1254, 1899
testDF <- rbind(getnetral[1:750,1:2], get_netral[1:500,1:2])
write.csv(testDF,"testNormalSVM2.csv")
trainDF <- rbind(getnetral[751:1899,1:2], get_netral[501:1254,1:2])
write.csv(trainDF,"trainNormalSVM2.csv")

#PERCOBAAN 2 - negatif vs positif
traine <- read.csv('trainNormalSVM.csv', stringsAsFactors = F)
new_train <- read.csv('testNormalSVM.csv', stringsAsFactors = F)
train <- rbind(traine, new_train)
#IF NEGATIF (-1) == -1, POSITIF (1) == 1
getpositif <- subset(train, is_kelas==1)
getnegatif <- subset(train, is_kelas==-1)
#perbandingan 1 : 2 --> 100 : 200 (negatif : positif) ||| Asli : 387, 867
testDF <- rbind(getpositif[1:200,1:2], getnegatif[1:100,1:2])
write.csv(testDF,"testNormalSVM3.csv")
trainDF <- rbind(getpositif[201:867,1:2], getnegatif[101:387,1:2])
write.csv(trainDF,"trainNormalSVM3.csv")

#ANIES DESEMBER - PERCOBAAN 1 
train <- read.csv('checkAniesDes.csv', stringsAsFactors = F)
#IF NETRAL (0) == 1, NOT_NETRAL (1/-1) == 0
train$is_kelas <- ifelse(train$is_kelas==0, 1, 0)
getnetral <- subset(train, is_kelas==1)
get_netral <- subset(train, is_kelas==0)
#perbandingan 10 : 13 --> 1000 : 1300 (-netral : netral) ||| Asli : 3908, 5162
testDF <- rbind(getnetral[1:1300,1:2], get_netral[1:1000,1:2])
write.csv(testDF,"testNormalAniesDes2.csv")
trainDF <- rbind(getnetral[1301:5162,1:2], get_netral[1001:3908,1:2])
write.csv(trainDF,"trainNormalAniesDes2.csv")

#ANIES DESEMBER - PERCOBAAN 2 
train <- read.csv('checkAniesDes.csv', stringsAsFactors = F)
#IF NEGATIF (-1) == -1, POSITIF (1) == 1
getpositif <- subset(train, is_kelas==1)
getnegatif <- subset(train, is_kelas==-1)
#perbandingan 10 : 15 --> 500 : 750 (negatif : positif) ||| Asli : 1566, 2342
testDF <- rbind(getpositif[1:750,1:2], getnegatif[1:500,1:2])
write.csv(testDF,"testNormalAniesDes3.csv")
trainDF <- rbind(getpositif[751:2342,1:2], getnegatif[501:1566,1:2])
write.csv(trainDF,"trainNormalAniesDes3.csv")
