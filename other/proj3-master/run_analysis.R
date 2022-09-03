# check if I've already downloaded the data
if (!file.exists("./data")) {
    dir.create("./data")
    file_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    file_name <- "Dataset.zip"
    download.file(file_url, destfile = file_name, method = "curl")
    unzip(zipfile = file_name, unzipdir = "./")
    file.rename(from = "UCI HAR Dataset", to = "data")
}

# load the data
df_features_train <- read.csv(file = file.path("data", "train", "X_train.txt"),
    header = FALSE, sep = "")
df_activity_train <- read.csv(file = file.path("data", "train", "y_train.txt"),
    header = FALSE, sep = "")
df_subject_train <- read.csv(file = file.path("data", "train", "subject_train.txt"),
    header = FALSE, sep = "")

df_features_test <- read.csv(file = file.path("data", "test", "X_test.txt"),
    header = FALSE, sep = "")
df_activity_test <- read.csv(file = file.path("data", "test", "y_test.txt"),
    header = FALSE, sep = "")
df_subject_test <- read.csv(file = file.path("data", "test", "subject_test.txt"),
    header = FALSE, sep = "")

features <- read.csv("./data/features.txt", header = FALSE, sep = "")
# second column is the feature
features <- features[, 2]
activities <- read.csv("./data/activity_labels.txt", header = FALSE, sep = "")
# second column is the activity
activities <- activities[, 2]

# rename the column names
colnames(df_features_train) <- features
colnames(df_features_test) <- features

colnames(df_subject_train) <- "Subject"
colnames(df_subject_test) <- "Subject"

colnames(df_activity_train) <- "Activity"
colnames(df_activity_test) <- "Activity"

# part 1:
# Merges the training and the test sets to create one data set.
df <- rbind(df_features_train, df_features_test)

# part 2:
# Extracts only the measurements on the mean and standard deviation for each measurement. 

df_names <- names(df)
indices_mean <- grep(pattern = "mean", x = df_names)
indices_std <- grep(pattern = "std", x = df_names)

df <- df[, c(indices_mean, indices_std)]

# part 3:
# Uses descriptive activity names to name the activities in the data set.
# And Also I added subjects as well.
df$Activity <- factor(rbind(df_activity_train, df_activity_test)$Activity)
df$Subject <- factor(rbind(df_subject_train, df_subject_test)$Subject)

levels(df$Activity) <- activities

df <- na.omit(df)

# part 4:
# Appropriately labels the data set with descriptive variable names.
df_names <- names(df)
df_names <- gsub(pattern = "^t", replacement = "Time", x = df_names)
df_names <- gsub(pattern = "^f", replacement = "Frequency", x = df_names)
df_names <- gsub(pattern = "Acc", replacement = "Accelerometer", df_names)
df_names <- gsub(pattern = "Gyro", replacement = "Gyroscope", df_names)
df_names <- gsub(pattern = "Mag", replacement = "Magnitude", df_names)
df_names <- gsub(pattern = "BodyBody", replacement = "Body", df_names)

names(df) <- df_names

# part 5:
# From the data set in step 4, creates a second, independent tidy data set with
# the average of each variable for each activity and each subject.
library(plyr)
df_clean <- aggregate(. ~Subject + Activity, df, mean)
df_clean <- df_clean[order(df_clean$Subject, df_clean$Activity), ]
write.table(df_clean, file = "tidydata.txt", row.name = FALSE)