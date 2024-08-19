# Get_Clean_Data_Final
The objective of this assignment is to transform a 'messy' data set into a 'tidy' data set

The script to execute was written as follows

##Step 1 Load dplyr package

library(dplyr)

## Step 2 download required files

filename <- "Coursera_DS3_Final.zip"
if (!file.exists(filename)){
  url1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(url1, destfile="url1data.csv")}

if (!file.exists("UCI HAR Dataset")) { 
  unzip("url1data.csv")}

##Step 3 creating dataframes
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

## Step 4 Merge testing and training datasets

X <- rbind(x_train, x_test)
Y<-rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)

##Extract SD and Mean
TidyData <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))

##Descriptive activity names for naming activities
TidyData$code <- activities[TidyData$code, 2]

## Step 5 Relabel TidyData

names(TidyData)[2] = "activity"
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscrope",names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body",names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t","Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))

##Step 6Create separate file with averages for separate activities and subjects
AveragesTable<-TidyData%>%group_by(activity, subject)%>%summarise_all(funs(mean))
    write.table(AveragesTable, file= "AveragesTable.txt", row.name = FALSE)

## Step 7 Review AveragesTable

    str(AveragesTable)
