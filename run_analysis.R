## part 0 data generation
test_x<-read.delim("X_test.txt", header = FALSE, sep = "",quote="\"", dec = ".")
test_y<-read.delim("y_test.txt", header = FALSE, sep = "",quote="\"", dec = ".")
test_s<-read.delim("subject_test.txt",header = FALSE, sep = "",quote="\"", dec = ".")
train_x<-read.delim("X_train.txt", header = FALSE, sep = "",quote="\"", dec = ".")
train_y<-read.delim("y_train.txt", header = FALSE, sep = "",quote="\"", dec = ".")
train_s<-read.delim("subject_train.txt", header = FALSE, sep = "",quote="\"", dec = ".")

features <- read.delim("features.txt",sep = "",header = FALSE)

colnames(train_x) = features[,2]
colnames(train_y) = "activity_ID"
colnames(train_s) = "subject_ID"

colnames(test_x) = features[,2]
colnames(test_y) = "activity_ID"
colnames(test_s) = "subject_ID"

## part 1 Merges the training and the test sets to create one data set.
my_train = cbind(train_y, train_s, train_x)
my_test = cbind(test_y, test_s, test_x)
my_data= rbind(my_train, my_test)

## part 2 Extracts only the measurements on the mean and standard deviation for each measurement.

my_MeanStandard <- my_data[, grepl("mean.." , names(my_data)) | grepl("std.." , names(my_data))]

## part 3 Uses descriptive activity names to name the activities in the data set
activitylabels <- read.delim("activity_labels.txt", sep = "", header = FALSE)
colnames(activitylabels) <- c('activity_ID','activity_name')
my_MeanStandard$activity_ID<-my_data[,1]
my_MeanStandard$subject_ID<-my_data[,2] 
my_MeanStandard_activitynames<-merge(my_MeanStandard, activitylabels, by='activity_ID', all.x=TRUE)

## part 4 Appropriately labels the data set with descriptive variable names.
my_MeanStandard_activitynames_col <- colnames(my_MeanStandard_activitynames)
my_MeanStandard_activitynames_col <- gsub("^f", "frequency ", my_MeanStandard_activitynames_col)
my_MeanStandard_activitynames_col <- gsub("^t", "time ", my_MeanStandard_activitynames_col)
colnames(my_MeanStandard_activitynames)<-my_MeanStandard_activitynames_col

##part5 From the data set in step 4, creates a second, independent tidy data set with the average 
##of each variable for each activity and each subject.
my_tidy_data <- aggregate(. ~activity_ID+subject_ID, data=my_MeanStandard_activitynames,
                           mean)
write.table(my_tidy_data, "my_tidy_data.txt", row.names = FALSE)
   