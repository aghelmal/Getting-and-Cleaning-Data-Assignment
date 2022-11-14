# Step 0: prepration
################################################################################################
# Setting WD
setwd("C:/Users/haghe/Documents/Coursera/Getting and Cleaning Data")
###############################################
# Reading data into R

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
Activitydf <- rbind(y_train, y_test) # combine two activities-data sets by rows
Featuresdf <- rbind(x_train, x_test) #combine two features-data sets by rows

# Name the columns
colnames(Featuresdf) <- t(features[2])
colnames(Activitydf) <- "Activity"
colnames(Subjectdf) <- "Subject"

# Merge the data
Data <- cbind(Featuresdf,Activitydf,Subjectdf)
#################################################################################################
#Step 2 - Extracts only the measurements on the mean and standard deviation for each measurement
library(dplyr)
selected <- Data %>% select(Subject, Activity, contains("mean"), contains("std")) 

#################################################################################################
# Step 3 - Uses descriptive activity names to name the activities in the data set
selected$Activity <- activities[selected$Activity, 2]

#################################################################################################
# Step 4 - Appropriately labels the data set with descriptive variable names
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
  group_by(Subject, Activity) %>%
  summarise_all(funs(mean))
write.table(TidyData, "TidyData.txt", row.name=FALSE)

str(TidyData)
TidyData