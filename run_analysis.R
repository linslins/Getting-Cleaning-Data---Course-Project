
# load data starting from the UCI HAR Datset downloaded and unziped
# in the working directory
# packages plyr, reshape2 to be installed

xtrain <- read.table("UCI HAR Dataset/train/X_train.txt", header=F)
ytrain <- read.table("UCI HAR Dataset/train/y_train.txt", header=F)
subtrain <- read.table("UCI HAR Dataset/train/subject_train.txt", header=F)
subtest <- read.table("UCI HAR Dataset/test/subject_test.txt", header=F)
xtest <- read.table("UCI HAR Dataset/test/X_test.txt", header=F)
ytest <- read.table("UCI HAR Dataset/test/y_test.txt", header=F)
actlabels <- read.table("UCI HAR Dataset/activity_labels.txt", header=F)
features <- read.table("UCI HAR Dataset/features.txt", header=F)

#giving activity names to y, and combining them:
library(plyr)
ytestactiv <- join(ytest, actlabels)
ytrainactiv <- join(ytrain, actlabels)
activities <- rbind(ytestactiv, ytrainactiv) #10299 obs, first test, then train
colnames(activities) <- c("code", "activity")

#combining subjects (first test, then train):
subjects <- rbind(subtest, subtrain)
colnames(subjects) <- "subject"

#combine all data for test and train:
alldata <- rbind(xtest, xtrain)

#use diff features as names for alldata columns:
colnames(alldata) <- features$V2

#select only columns which names include mean() and std():
relevantvariables <- alldata[, grepl("[Mm]ean\\(\\)",names(alldata))|
                   grepl("[Ss][Tt][Dd]\\(\\)", names(alldata))]

#combine all the selected data values with the activity and subject
finaldata <- cbind(subjects, activities[,2], relevantvariables)
colnames(finaldata)[2] <- "activity"

#melt into vertical form
library(reshape2)
datamolten <- melt(finaldata, id=c("subject", "activity"))

#back to wide form, with average values of each measurement 
#for every subject and activity
productwide <- dcast(datamolten, subject+activity ~ variable, mean)

#OPTION: if narrow version is better:
narrowchaos <- melt(productwide, id=c("subject", "activity"))
productnarrow <- arrange(narrowchaos, subject,activity)

#print product table for submission in Coursera:
#(the name will be productwide because it is the type of format I choose,
#it could be productnarrow if the other disposition is preferred)
write.table(productwide, file="productwide.txt", row.name=F)
