# Getting-Cleaning-Data---Course-Project
Repo to submit course project for the Coursera Getting and Cleaning Data course. Includes script with code, ReadMe and CodeBook

The script `run_analysis.R` produces a tidy data set of averages of certain values found in the downloaded folder *UCI HAR Dataset*.
This initial dataset includes data obtained from accelerators in Samsung Galaxy S smartphones, used both in *test* and *train* environments by 30 people.
This data includes direct measurements and Fourier transformations of those, in multiple dimensions. 
In particular, those that are mean and standard deviation of the main measurements, identified by the addendum to the name *-mean()* or *-std()*, are the ones that the instructions demand to have averaged by subject exercising and type of activity measured.
It has been considered for the analysis that other sets of variables also including the word *mean* were not to be included since they are not strictly averages of measurements but further calculations done to other variables (for instance, in the explanatory files included in the database folder states: "*meanFreq()*: Weighted average of the frequency components to obtain a mean frequency*)

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

- 

