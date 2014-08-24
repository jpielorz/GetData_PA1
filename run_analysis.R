# R Script for course project work on "Getting and Cleaning Data"
#
# Note: A detailed decription of the steps taken to solve the assignment
# can be found in README.md


# 0. Downloading and extracting raw data to local directory

setwd("~/coursera//getting_and_cleaning_data/data/")

# Downloading zip file from url (if it doesn't exist)

source_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
local_file <- "UCI_HAR_Dataset.zip"
if (!file.exists(local_file)) {
      download.file(source_url,local_file, method = "curl")
      library(tools)       # for md5 checksum
      sink("datadownload_metadata.txt")   # 
      print("Download date:")
      print(Sys.time() )
      print("Download URL:")
      print(source_url)
      print("Downloaded file Information")
      print(file.info(local_file))
      print("Downloaded file md5 Checksum")
      print(md5sum(local_file))
      sink()
}

# Unzipping and extracting the files to local directory

filelist <- unzip("UCI_HAR_Dataset.zip", list=TRUE)
filename <- filelist$Name
unzip("UCI_HAR_Dataset.zip", files = filename, overwrite = TRUE)

# 1. Merging the training and the test sets to create one dataset

# First the files in test directory

test_files <- filename[16:18]
testData <- do.call(cbind, lapply(test_files,read.table))

# Secondly, the files in train directory

train_files <- filename[30:32]
trainData <- do.call(cbind, lapply(train_files,read.table))

# Combine both datasets      
combinedData <- rbind(testData,trainData)

# 2. Extracting only mean and standard deviation for each measurement

# Extract all feature names from features.txt

features <- read.table(filename[2])

# Search for occurances of mean and std and create vector with considered features

col_indices <- grep("([Mm]ean|[Ss]td)", features$V2)
feature_names <- features[col_indices,2]

# Shift indices by one to take into account for subject column included with cbind() and add indices 1 and 563.

col_indices_new <- col_indices +1
col_indices_new <- c(1,col_indices_new,563)

# Apply vector with indices to combinedData to extract mean and standard deviations.

extractedData <- combinedData[,col_indices_new]

# 3. Using descriptive activity names to name the activities in the dataset

# Take names from activity_labels.txt

activity_labels <- read.table(filename[1])
activities <- activity_labels[extractedData[,88],2]
extractedData[,88] <- activities
table(extractedData[,88])

# 4. Labeling the dataset with descriptive variable names

# Convert special characters in feature_names

descriptive_names <- gsub("-", "_", gsub("\\()", "", feature_names))
descriptive_names <- gsub(",|\\(", "_", gsub("\\)", "", descriptive_names))

# Add names for new columns subjectId and activities

descriptive_names <- c("subjectId",descriptive_names,"activities")
names(extractedData) <- descriptive_names

# 5. Creating a second, independent tidy dataset

tidyData <- aggregate(extractedData[,2:87], data=extractedData, by = list(subjectId=extractedData$subjectId,activities=extractedData$activities),mean)

# Print output to txt file for submission

write.table(tidyData, "~/coursera//repos//GetData_PA1/tidy_data.txt", row.names = FALSE)
