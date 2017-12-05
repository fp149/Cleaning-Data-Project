# Getting and Cleaning Data - Week 4 final project

# import the data

test_data <- read.table("C:/Coursera/DataScience/c3Final/UCI HAR Dataset/test/x_test.txt")
train_data <- read.table("C:/Coursera/DataScience/c3Final/UCI HAR Dataset/train/x_train.txt")
data_labels <- read.table("C:/Coursera/DataScience/c3Final/UCI HAR Dataset/features.txt")

# import the labels

test_activities <- read.table("C:/Coursera/DataScience/c3Final/UCI HAR Dataset/test/y_test.txt")
train_activities <- read.table("C:/Coursera/DataScience/c3Final/UCI HAR Dataset/train/y_train.txt")
activity_definitions <- read.table("C:/Coursera/DataScience/c3Final/UCI HAR Dataset/activity_labels.txt")

test_subjects <- read.table("C:/Coursera/DataScience/c3Final/UCI HAR Dataset/test/subject_test.txt")
train_subjects <- read.table("C:/Coursera/DataScience/c3Final/UCI HAR Dataset/train/subject_train.txt")

# create labelled sets
# do this before merge to prevent order being mixed up

train_set <- cbind(train_activities, train_subjects, train_data)
test_set <- cbind(test_activities, test_subjects, test_data)

# merge train and test sets

merged_data <- rbind.data.frame(train_set, test_set)

# apply column names

names(merged_data)[3:ncol(merged_data)] <- as.vector(data_labels$V2)
names(merged_data)[2] <- "Subject"

# apply activity descriptions

merged_data <- merge(activity_definitions, merged_data, by.x = "V1", by.y = "V1")
  # remove activity index column
merged_data <- within(merged_data, rm("V1"))

names(merged_data)[1] <- "Activity"

# Extract only mean and standard deviation data

  # [^F] excludes meanFreq entries
cols_to_keep <- grep("-mean[^F]|-std|Activity|Subject", names(merged_data), value = TRUE) 

merged_data <- merged_data[, cols_to_keep]

# clean up workspace
rm(list = ls()[ls() != "merged_data"])

# create table with aggregated data
tidy_averaged_data <- aggregate(merged_data[, 3:ncol(merged_data)], list(merged_data$Activity, merged_data$Subject), mean)
names(tidy_averaged_data)[1:2] <- c("Activity", "Subject")

# export data table
write.table(tidy_averaged_data, "C:/Coursera/DataScience/c3Final/tidy_averaged_data.txt")

