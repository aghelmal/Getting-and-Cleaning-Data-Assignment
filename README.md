# Getting-and-Cleaning-Data-Assignment
This repository is my submission for the coursera course "Getting and Cleaning Data". 
Below is the explanation on how all of the scripts work and how they are connected.

"CodeBook.md" file describes the variables, the data (Human Activity Recognition Using Smartphones), and any transformations or work that has been performed to clean up the data 

The script "run_analysis.R" runs mainly the following steps:

- Merging the training and the test sets to create one data set.
- Extracting only the measurements on the mean and standard deviation for each measurement.
- Using descriptive activity names to name the activities in the data set
- Appropriately labeling the data set with descriptive variable names.
- From the data set in step 4, creating a second, independent tidy data set with the average of each variable for each activity and each subject
