This file attempts to describes the steps perfemored for analysis. (i.e., the variables, the data, and any transformations or work that has been performed to clean up the data "Human Activity Recognition Using Smartphones").
##############################################################################################
Step 0: prepration: In this step I set the working directory and read data sets (e.g. training and test data) into R:
# Reading features and activities data
features <- read.table("UCI HAR Dataset/features.txt")
activities <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)
# Reading test data
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
# Reading training data
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
##############################################################################################
# Step 1 - Merge the training and the test sets to create one data set

Subjectdf <- rbind(subject_train, subject_test)
Activitydf <- rbind(y_train, y_test) # rbind() function combines two activity-data sets by rows
Featuresdf <- rbind(x_train, x_test) # rbind() function combines two feature-data sets by rows

# Name the columns
colnames(Featuresdf) <- t(features[2])
colnames(Activitydf) <- "Activity"
colnames(Subjectdf) <- "Subject"

# Merge the data
Data <- cbind(Featuresdf,Activitydf,Subjectdf) # cbind() function is used to merge and combine by columns
#################################################################################################
#Step 2 - Extracts only the measurements on the mean and standard deviation for each measurement
library(dplyr) # this is needed for the following code
selected <- Data %>% select(Subject, Activity, contains("mean"), contains("std")) # here, two columns of "Subject" and "Activity", as well as the measurements on the mean and standard deviation are selcted

#################################################################################################
# Step 3 - Uses descriptive activity names to name the activities in the data set
selected$Activity <- activities[selected$Activity, 2] # using second column of the data file "activities", numbers of activities are replaced with their names

#################################################################################################
# Step 4 - Appropriately labels the data set with descriptive variable names
# All "Acc"s are  replaced by Accelerometer, similarly the appropriate name is given to other variables
names(selected)<-gsub("Acc", "Accelerometer", names(selected)) 
names(selected)<-gsub("Gyro", "Gyroscope", names(selected)) 
names(selected)<-gsub("BodyBody", "Body", names(selected))
names(selected)<-gsub("Mag", "Magnitude", names(selected))
names(selected)<-gsub("^t", "Time", names(selected))
names(selected)<-gsub("^f", "Frequency", names(selected))
names(selected)<-gsub("tBody", "TimeBody", names(selected))
names(selected)<-gsub("-mean()", "Mean", names(selected), ignore.case = TRUE)
names(selected)<-gsub("-std()", "STD", names(selected), ignore.case = TRUE)
names(selected)<-gsub("-freq()", "Frequency", names(selected), ignore.case = TRUE)
names(selected)<-gsub("angle", "Angle", names(selected))
names(selected)<-gsub("gravity", "Gravity", names(selected))
#############################################################################################
# Step 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
TidyData <- selected %>%
  group_by(Subject, Activity) %>% # groupping by subject and activity
  summarise_all(funs(mean)) # taking the means of each variable for each group (activity and subject)
write.table(TidyData, "TidyData.txt", row.name=FALSE) # exporting TidyData into .txt file.
