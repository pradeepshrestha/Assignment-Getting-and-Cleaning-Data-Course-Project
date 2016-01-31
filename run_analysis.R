##1 merge the test and train data set into one by appending
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")
dim(subject_test)
X_test<-read.table("./UCI HAR Dataset/test/X_test.txt")
dim(X_test)
y_test<-read.table("./UCI HAR Dataset/test/y_test.txt")
dim(y_test)
test_data<-cbind(subject_test, y_test, X_test)
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")
dim(subject_train)
X_train<-read.table("./UCI HAR Dataset/train/X_train.txt")
dim(X_train)
y_train<-read.table("./UCI HAR Dataset/train/y_train.txt")
dim(y_train)
train_data<-cbind(subject_train, y_train, X_train)
dim(train_data)
merged_data<-rbind(test_data, train_data)
dim(merged_data)
##---------------------------------------------------------------
##2 Extracts only the measurements on the mean and standard deviation for each measurement.
colnames(merged_data)[c(1,2)]<-c("subject_id", "activity_name")
col_names<-read.table("./features.txt", stringsAsFactors = FALSE)
col_names_subset<-col_names[grep("mean|std", col_names$V2), ]
col_names2$V1<-col_names2$V1+2
merged_data_subset<-merged_data[, c(1,2,col_names2$V1)]
##------------------------------------------------------------
##3  Uses descriptive activity names to name the activities in the data set
activity_labels<-read.table("./activity_labels.txt")
lookupVec<-activity_labels$V2
merged_data_subset$activity_name<-sapply(merged_data_subset$activity_name, function(x) x<-lookupVec[x])
##----------------------------------------------------------
##4  Appropriately labels the data set with descriptive variable names.
colnames(merged_data_subset)[3:81]<-col_names2$V2
colnames(merged_data_subset)<-gsub("[-_()]", "", names(merged_data_subset))
##----------------------------------
##5  From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(dplyr)
tidy_data<-merged_data_subset %>% group_by(subject_id, activity_name) %>% summarize_each(funs(mean))
##---------------------------------------------------
