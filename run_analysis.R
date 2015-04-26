# clean work space
rm(list=ls())

# variables indicating where the data files are
data_dir <- './UCI HAR Dataset/'
train_dir <- paste(data_dir,'train/',sep='')
test_dir <- paste(data_dir,'test/',sep='')
train_X_file <- paste(train_dir,'X_train.txt',sep='')
test_X_file <- paste(test_dir,'X_test.txt',sep='')
train_Y_file <- paste(train_dir,'Y_train.txt',sep='')
test_Y_file <- paste(test_dir,'Y_test.txt',sep='')
train_subject_file <- paste(train_dir,'subject_train.txt',sep='')
test_subject_file <- paste(test_dir,'subject_test.txt',sep='')
feature_name_file <- paste(data_dir,'features.txt',sep='')
activity_name_file <- paste(data_dir,'activity_labels.txt',sep='')

# read feature names
features <- read.table(feature_name_file,stringsAsFactors = FALSE)
# only include feature with 'mean()' or 'std()' in it
include <- grepl('(mean\\(\\))|(std\\(\\))',features[[2]])
included_feat_names <- features[[2]][include]
# remove unused object
rm(features)

# read X data
train_X_data <- read.table(train_X_file)[include]
test_X_data <- read.table(test_X_file)[include]

# merge train data and test data
data_merged <- rbind(train_X_data,test_X_data)
# remove unused object
rm(train_X_data,test_X_data)

# read activity labels
activity_labels <- read.table(activity_name_file,stringsAsFactors = FALSE)

# read Y data and replace it with corresponding activity label
train_Y_data <- activity_labels[[2]][read.table(train_Y_file,stringsAsFactors = FALSE)[[1]]]
test_Y_data <- activity_labels[[2]][read.table(test_Y_file,stringsAsFactors = FALSE)[[1]]]

# read subject data
train_subject <- read.table(train_subject_file)
test_subject <- read.table(test_subject_file)

# merge X data, Y data and subject data into one data frame
data_merged <- cbind(data_merged,c(train_Y_data,test_Y_data),rbind(train_subject,test_subject))
# remove unused object
rm(train_Y_data,test_Y_data,train_subject,test_subject)
# assign column names to merged data frame
colnames(data_merged) <- c(included_feat_names,'activity','subject')
# remove unused object
rm(include,included_feat_names,activity_labels)

# calculate mean for each measurement, each activity and subject
summary <- lapply(data_merged[1:66],function(measure) {
  tapply(measure,list(data_merged[['activity']],data_merged[['subject']]),FUN=mean,simplify=FALSE)
})

# convert the summary to a data frame so it can be saved in a file
summary_data_frame <- data.frame(lapply(summary,function(measure) {
  sapply(measure,sum)
}))
summary_data_frame <- cbind(summary_data_frame,rep(rownames(summary[[1]]),length(colnames(summary[[1]]))),rep(colnames(summary[[1]]),length(rownames(summary[[1]]))))
colnames(summary_data_frame) <- c(colnames(data_merged)[1:66],'activity','subject')

# write data to a text file
write.table(data_merged,'merged_data.txt',row.names=FALSE)
write.table(summary_data_frame,'summary.txt',row.names=FALSE)