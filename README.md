# Getting-Cleaning-Data---Course-Project
Repo to submit course project for the Coursera Getting and Cleaning Data course. Includes script with code, ReadMe and CodeBook

The script `run_analysis.R` produces a tidy data set of averages of certain values found in the downloaded folder *UCI HAR Dataset*.
This initial dataset includes data obtained from accelerators in Samsung Galaxy S smartphones, used both in *test* and *train* environments by 30 people.
This data includes direct measurements and Fourier transformations of those, in multiple dimensions. 
In particular, those that are mean and standard deviation of the main measurements, identified by the addendum to the name *-mean()* or *-std()*, are the ones that the instructions demand to have averaged by subject exercising and type of activity measured.
It has been considered for the analysis that other sets of variables also including the word *mean* were not to be included since they are not strictly averages of measurements but further calculations done to other variables (for instance, in the explanatory files included in the database folder states: "*meanFreq()*: Weighted average of the frequency components to obtain a mean frequency*").
Advise from the following posts in the Course Discussion Forums has been used to reach that assumption: *https://class.coursera.org/getdata-030/forum/thread?thread_id=107* and *https://class.coursera.org/getdata-030/forum/thread?thread_id=37*.


The process that follows the script `run_analysis.R` is the following:

- The script sets the base in which it is supose to run. It requires the script to be placed along with the *UCI HAR Dataset* in the working directory of R.
- Also, a couple of packages need to be installed: *plyr* and *reshape2* (the script will take care of loading them when necessary).
- It reads all the necessary files from their location within the downloaded folder with a `read.table`.

```
xtrain <- read.table("UCI HAR Dataset/train/X_train.txt", header=F)
ytrain <- read.table("UCI HAR Dataset/train/y_train.txt", header=F)
subtrain <- read.table("UCI HAR Dataset/train/subject_train.txt", header=F)
subtest <- read.table("UCI HAR Dataset/test/subject_test.txt", header=F)
xtest <- read.table("UCI HAR Dataset/test/X_test.txt", header=F)
ytest <- read.table("UCI HAR Dataset/test/y_test.txt", header=F)
actlabels <- read.table("UCI HAR Dataset/activity_labels.txt", header=F)
features <- read.table("UCI HAR Dataset/features.txt", header=F)
```

- It loads the *plyr* package and joins the activity labels with the *y* listings, to afterwards combine them in a single file (starting with the *test* files, followed by the *train*)

```
library(plyr)
ytestactiv <- join(ytest, actlabels)
ytrainactiv <- join(ytrain, actlabels)
activities <- rbind(ytestactiv, ytrainactiv) #10299 obs, first test, then train
colnames(activities) <- c("code", "activity")
```

- It combines in a single column the list of subjects for *test* and *train* (in that order), and calls *subject* this column

```
subjects <- rbind(subtest, subtrain)
colnames(subjects) <- "subject"
```

- It combines all the data measurements in a single dataframe, binding by rows (starting with the *test* files, followed by the *train*)

```
alldata <- rbind(xtest, xtrain)
```

- It takes the names of the features, and uses them to name the colums on *alldata*

```
colnames(alldata) <- features$V2
```

- As it is explained earlier in this document, it select only the columns where the measurement name includes *-mean()* or *-std()*

```
relevantvariables <- alldata[, grepl("[Mm]ean\\(\\)",names(alldata))|grepl("[Ss][Tt][Dd]\\(\\)", names(alldata))]
```

- It binds by columns all the data measured and selected with their correspondent subject and type of activity. It renames the *activity* column

```
finaldata <- cbind(subjects, activities[,2], relevantvariables)
colnames(finaldata)[2] <- "activity"
```

- It melts *finaldata* into a long 4-column data frame with 679734 rows where there is a value for each subject, activity and selected relevant variable

```
library(reshape2)
datamolten <- melt(finaldata, id=c("subject", "activity"))
```

- It provides the final objective of a tidy and wide form data file, called *productwide*, where there is the mean of each relevant variable for every subject and type of activity

```
productwide <- dcast(datamolten, subject+activity ~ variable, mean)
```

- OPTIONAL. In case the user prefers it, the script creates another final tidy data file, in this case in narrow form and called *productnarrow*. In addition to the *subject* and *activity* column, there is a column for each relevant variable and another for its correspondent value

```
narrowchaos <- melt(productwide, id=c("subject", "activity"))
productnarrow <- arrange(narrowchaos, subject,activity)
```

- It prints the final data file in the form that is necessary to be submitted on Coursera. (It gives indication as to how to do it if the alternative narrow version is preferred)

```
#print product table for submission in Coursera:
#(the name will be productwide because it is the type of format I choose,
#it could be productnarrow if the other disposition is preferred)
write.table(productwide, file="productwide.txt", row.name=F)
```
