## DOWNLOAD AND UNZIP DATA FILES

## DESCRIPTION OF THE DATA: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
## DATA: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## EXTRACT (MEAN,SD) FROM FEATURES
feature.names=read.table("UCI HAR Dataset/features.txt")
desired.features=grep("std|mean", feature.names$V2)

## READ AND MERGE (TRAIN,TEST) OF FEATURES
train.features=read.table("UCI HAR Dataset/train/X_train.txt")
desired.train.features=train.features[,desired.features]
test.features=read.table("UCI HAR Dataset/test/X_test.txt")
desired.test.features=test.features[,desired.features]

total.features=rbind(desired.train.features, desired.test.features)

## BIND COLUMN NAMES TO FEATURES
colnames(total.features)=feature.names[desired.features, 2]

## READ AND MERGE (TRAIN,TEST) ACTIVITIES
train.activities=read.table("UCI HAR Dataset/train/y_train.txt")
test.activities=read.table("UCI HAR Dataset/test/y_test.txt")
total.activities=rbind(train.activities, test.activities)

## BIND COLUMN NAMES TO ACTIVITIES
activity.labels=read.table("UCI HAR Dataset/activity_labels.txt")
total.activities$activity=factor(total.activities$V1, levels = activity.labels$V1, labels = activity.labels$V2)

## READ AND MERGE (TRAIN,TEST) SUBJECT ID'S
train.subjects=read.table("UCI HAR Dataset/train/subject_train.txt")
test.subjects=read.table("UCI HAR Dataset/test/subject_test.txt")
total.subjects=rbind(train.subjects, test.subjects)

## MERGE (SUBJECT NAMES, ACTIVITY NAMES)
subjects.and.activities=cbind(total.subjects, total.activities$activity)
colnames(subjects.and.activities)=c("subject.id", "activity")

## MERGE WITH FEATURES
activity.frame=cbind(subjects.and.activities, total.features)

## COMPUTE MEAN OF ALL MEASURES GROUPED BY SUBJECT_ID AND ACTIVITY
result.frame=aggregate(activity.frame[,3:81], by = list(activity.frame$subject.id, activity.frame$activity), FUN = mean)
colnames(result.frame)[1:2]=c("subject.id", "activity")
write.table(result.frame, file="mean_measures.txt", row.names = FALSE)
