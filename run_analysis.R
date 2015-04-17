# run_analysis.R
#
# You should create one R script called run_analysis.R that does the following. 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each 
#  measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set 
#  with the average of each variable for each activity and each subject.


# Read all the files

# train set
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt",header=FALSE,
                      col.names=c("activity_code"))
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt",
                            header=FALSE,
                            col.names = c("subject"))

# test set
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt",header=FALSE,
                     col.names=c("activity_code"))
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt",
                           header=FALSE,
                           col.names = c("subject"))

# features (column names) and activity labels
features <- read.table("./UCI HAR Dataset/features.txt", header=FALSE, 
                       stringsAsFactors=FALSE)
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", 
                              header=FALSE, stringsAsFactors=TRUE,
                              col.names=c("activity_code", "activity_name"))


# Merge the training and the test sets to create one data set (step 1)

train <- cbind(subject_train, x_train, y_train)
test <- cbind(subject_test, x_test, y_test)
data <- rbind(train, test)

# Appropriately labels the data set with descriptive variable names (step 4)
# Chose to do it first, in order to avoid having a dataframe with 
# non-significant column names
colnames(data) <- c("subject", features[,2], "activity_code")

# Extract only the measurements on the mean and standard deviation for each 
# measurement. (step 2)
# Chose to filter on measurement names containing "std" or "mean"
# keep also the first (subject) and last (activity_name) columns
indices <- c(1, grep("*std*|*mean*", colnames(data)), length(colnames(data)))
filtered_data <- data[ ,indices]


# Use descriptive activity names to name the activities in the data set (step3)
# merge data set and activity table; drop activity code (first column)
filtered_data <- merge(x=filtered_data, y=activity_labels, by="activity_code")
tidy_data <- filtered_data[ ,2:length(filtered_data)]

# Write tidy data in a file
write.table(tidy_data, file="tidy.txt", row.name=FALSE)



