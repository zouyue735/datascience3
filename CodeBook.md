# CodeBook
After running the script, you should get two files: merged_data.txt and summary.txt

## merged_data.txt
This files contains all the mean and std part of the measurements in train and test set, along with the activity labels and subjects.
Each row corresponds to a record in train set or test set, with the first 66 elements as measurements with corresponding measurement name as column name.
The 67th column 'activity' contains activity labels, and the 68th column 'subject' contains the subjects.

## summary.txt
This file contains the summary of the data in merged_data.txt
The first 66 columns are the average values for each measurement, each activity and each subject. With column names as measurement name, and the last two columns as activity label and subject.