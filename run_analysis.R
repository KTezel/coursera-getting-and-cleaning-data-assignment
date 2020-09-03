
##Install package dplyr
library(dplyr)

## set the working directory to the folder where the file resides
setwd("./Coursera/Data Science Specialization/Getting and Cleaning Data/Week 4/Assignment")

## read features and activity data
features <- read.table("features.txt", col.names = c("Row", "Function"))
activities <- read.table("./activity_labels.txt", col.names = c("Activity_Code", "Activity_Description"))

## Read test data: subject_test, x_test and y_test
subject_test <- read.table("./test/subject_test.txt", col.names = "Subject")
x_test <- read.table("./test/X_test.txt", col.names = features$Function)
y_test <- read.table("./test/y_test.txt", col.names = "Activity_Code")

## Read test data: subject_test, x_test and y_test
subject_train <- read.table("./train/subject_train.txt", col.names = "Subject")
x_train <- read.table("./train/X_train.txt", col.names = features$Function)
y_train <- read.table("./train/y_train.txt", col.names = "Activity_Code")


##Step 1: Merges the training and the test test to create one data set
x_test_merged <- rbind(x_train, x_test)
y_test_merged <- rbind(y_train, y_test)
subject_merged <- rbind(subject_train, subject_test)
full_data_merged <- cbind(subject_merged, y_test_merged, x_test_merged)


##Step 2: Extracts only the measurements on the mean and standard deviation for each measurement
extracted_measures <- full_data_merged %>% select(Subject, Activity_Code, contains("mean") ,contains("std"))

##Step 3: Uses descriptive activity names for the rows under the Activity_Code column in extracted_measures_data
extracted_measures$Activity_Code <- activities[extracted_measures$Activity_Code, 2]


##Step 4: Appropriately labels the data set with descriptive variable names
names(extracted_measures)[1] <- "Participants"
names(extracted_measures)[2] <- "Activity_Description"
names(extracted_measures)<-gsub("Acc", "Accelerometer", names(extracted_measures))
names(extracted_measures)<-gsub("Gyro", "Gyroscope", names(extracted_measures))
names(extracted_measures)<-gsub("BodyBody", "Body", names(extracted_measures))
names(extracted_measures)<-gsub("Mag", "Magnitude", names(extracted_measures))
names(extracted_measures)<-gsub("^t", "Time", names(extracted_measures))
names(extracted_measures)<-gsub("^f", "Frequency", names(extracted_measures))
names(extracted_measures)<-gsub("tBody", "TimeBody", names(extracted_measures))
names(extracted_measures)<-gsub("-mean()", "Mean", names(extracted_measures), ignore.case = TRUE)
names(extracted_measures)<-gsub("-std()", "STD", names(extracted_measures), ignore.case = TRUE)
names(extracted_measures)<-gsub("-freq()", "Frequency", names(extracted_measures), ignore.case = TRUE)
names(extracted_measures)<-gsub("angle", "Angle", names(extracted_measures))
names(extracted_measures)<-gsub("gravity", "Gravity", names(extracted_measures))

##Step 5: Create an independent tidy data set with the average of each variable for each activity and each subject
final_data <- extracted_measures %>% group_by(Participants, Activity_Description) %>% summarise_all(funs(mean))
write.table(final_data, "Final_Data.txt", row.names = FALSE)




