##Merge testing and training datasets
X <- rbind(x_train, x_test)
Y<-rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)

##Extract SD and Mean
TidyData <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))

##Descriptive activity names for naming activities
TidyData$code <- activities[TidyData$code, 2]

##Relabel TidyData
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

##Create separate file with averages for separate activities and subjects
AveragesTable<-TidyData%>%group_by(activity, subject)%>%summarise_all(funs(mean))
    write.table(AveragesTable, file= "AveragesTable.txt", row.name = FALSE)

##Review AveragesTable
    str(AveragesTable)