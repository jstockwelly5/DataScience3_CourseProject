## Coursera Data Science Getting and Cleaning Data Course
## Course Project
## This script will:  1)  merge training and test sets to create one data set  2) Extract measurements on the mean and standard dev for each 
## 3)  Use descriptive activity names to name activities  4)  Label data set with descriptive variable names  5)  Create second tidy data set with averages

## Load data into R

library(reshape2)

setwd("UCI HAR Dataset")

features = read.table("features.txt")
activity = read.table("activity_labels.txt")

setwd("test")

subjecttest = read.table("subject_test.txt")
colnames(subjecttest) <- "Subject"
testdata = read.table("X_test.txt")
testlabel = read.table("y_test.txt")
colnames(testlabel) <- "Label"

setwd("..")
setwd("train")

subjecttrain = read.table("subject_train.txt")
colnames(subjecttrain) <- "Subject"
traindata = read.table("X_train.txt")
trainlabel = read.table("y_train.txt")
colnames(trainlabel) <- "Label"

## Combine labels into each dataset
testmerged = cbind(testdata, testlabel, subjecttest)
trainmerged = cbind(traindata, trainlabel, subjecttrain)

## Combine datasets
fulldata = rbind(trainmerged, testmerged)

## Relabel fulldata with meaningful variable names
colnames(fulldata) <- c(as.character(features[,2]), "Label", "Subject")

## Replace activity code values with descriptive names
activityfactors = factor(fulldata$Label, levels = activity[,1], labels = activity[,2])

fulldata$Activity = activityfactors
fulldata$Label = NULL

## Extract only mean and standard dev measurements
good_data = fulldata[,c(1:6, 41:46, 81:86, 121:126, 161:166, 201:202, 214:215, 227:228, 240:241, 253:254, 266:271, 345:350, 424:429, 503:504, 516:517, 529:530, 542:543, 562:563)]

## Create second dataset with average of each variable for each activity and each subject
meltdata = melt(good_data, id=c("Subject", "Activity"))
avgData = dcast(meltdata, Activity + Subject ~ variable, mean)

## Output tidy dataset
write.table(avgData, file = "CourseProject.txt", row.name=FALSE)

