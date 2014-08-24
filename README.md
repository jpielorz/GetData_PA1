---
title: "Course Project for Getting and Cleaning Data"
author: "jip"
date: "Friday, August 22, 2014"
output: html_document
---

## Scope

The purpose of this work is to create a tidy dataset as course project for the coursera online course "Getting and Cleaning Data". The data used for this analysis represents data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

## References

For the course work the following sources were most valuable:

* The [video lectures](https://class.coursera.org/getdata-006/lecture) from the "Getting and Cleaning Data" course offered on Coursera by the Johns Hopkins university
* [David's Course Project FAQ](https://class.coursera.org/getdata-006/forum/thread?thread_id=43) with very useful threats from David Hood and several coursera students

The original work is described in:

* Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

## Description of files in the repo

In the repo the following files can be found:

* README.md: A README file with a description of all files and an explanation of the analysis files
* CodeBook.md: A code book with a description of all the variables and summaries that were calculated
* run_analysis.R: The R script for producing the tidy dataset
* tidy_data.txt: A txt file with the tidy dataset

## Summary of the actual task

Create an R script called run_analysis.R that does the following: 

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

In the following I will go through the steps above and briefly explain how I implemented a solution in R.

## 0. Downloading and extracting raw data to local directory

This part is actually not required in the Rscript but for completeness I still like to include it here. Feel free to skip this section.

### Downloading zip file from url (if it doesn't exist)


```r
      setwd("~/coursera//getting_and_cleaning_data/data/")
      source_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
      local_file <- "UCI_HAR_Dataset.zip"

# Download file and produce a metafile if it doesn't exist
      
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
```


### Unzipping and extracting the files to local directory


```r
      filelist <- unzip("UCI_HAR_Dataset.zip", list=TRUE)
      filename <- filelist$Name
      unzip("UCI_HAR_Dataset.zip", files = filename, overwrite = TRUE)
```

### Structure of the raw data

Once the raw data is extracted, one finds in the folder several txt files and two directories with training and test datasets that have the same structure: A subfolder with signal data that can be completely ignored for this exercise and 
three txt files including the data:

* The X_test.txt file contains the actual data with all observations
* The y_test.txt contains the activity label for each row in the X_test.txt
* The subject_test.txt file containing the subject ID for each row in the X_test.txt.

If you play a bit around with the raw data. e.g. comparing their dimensions, you find that they should be put together as illustrated in the nice plot by David Wood.

![nice figure](overview_files.png)

## 1. Merging the training and the test sets to create one dataset

Using the filename vector created when unzipping the data, on can first cbind separately the three files for each - the training and the test - datasets. In a second step all data can be merged into one dataframe with rbind.


```r
# First the files in test directory
      test_files <- filename[16:18]
      testData <- do.call(cbind, lapply(test_files,read.table))

# Secondly, the files in train directory
      train_files <- filename[30:32]
      trainData <- do.call(cbind, lapply(train_files,read.table))

# Combine both datasets      
      combinedData <- rbind(testData,trainData)
```

## 2. Extracting only mean and standard deviation for each measurement

The information we need for this is in the second column of the original features.txt file.


```r
     features <- read.table(filename[2])
```

Find all occurances of mean and std in features including upper and lower case. Use indices to extract all important feature names that we will need later in 4. for naming the variables properly.


```r
      col_indices <- grep("([Mm]ean|[Ss]td)", features$V2)
      feature_names <- features[col_indices,2]
```

Shift indices by one to take into account for subject column included with cbind() and add indices 1 and 563.


```r
      col_indices_new <- col_indices +1
      col_indices_new <- c(1,col_indices_new,563)
```

Apply vector with indices to combinedData to extract mean and standard deviations.


```r
      extractedData <- combinedData[,col_indices_new]
```


## 3. Using descriptive activity names to name the activities in the dataset

The activity names can be found in the original activity_labels.txt file. It holds a table where each activity is labeled with a number. These numbers are not very descriptive but are used in the y_test.txt to match observations with activities. Now we substitute these numbers with the actual activity names.



```r
      activity_labels <- read.table(filename[1])
      activities <- activity_labels[extractedData[,88],2]
      extractedData[,88] <- activities
      table(extractedData[,88])
```

```
## 
##             LAYING            SITTING           STANDING 
##               1944               1777               1906 
##            WALKING WALKING_DOWNSTAIRS   WALKING_UPSTAIRS 
##               1722               1406               1544
```

## 4. Labeling the dataset with descriptive variable names

For my personal taste the variable names from the features list are already descriptive, since I do prefer short names like "fBodyAcc-std()-Z" instead of "FastFourierTransformationBodyAccelerationStandardDeviationZ". To improve the readability even further (at least to my extent), I will drop the empty braces "()" and convert "-" to "_" in all variable names. 


```r
      descriptive_names <- gsub("-", "_", gsub("\\()", "", feature_names))
```

In the angle(.) expressions, I have to deal with the braces somehow, since otherwise they will be coerced to dots. I choose to drop the closing braces and convert the opening braces and commas to underscores.



```r
      descriptive_names <- gsub(",|\\(", "_", gsub("\\)", "", descriptive_names))
```


Now we have to add the variable names "subjectId" and "activities" for the first and last column of the extracted data and to assign the new variable names as column names for the extracted dataset.


```r
      descriptive_names <- c("subjectId",descriptive_names,"activities")
      names(extractedData) <- descriptive_names
```


## 5. Creating a second, independent tidy dataset

As a final step, we would like to create a second, independent tidy dataset with the average of each variable for each activity and each subject. For this we aggregate the dataset on activity and subject.


```r
      tidyData <- aggregate(extractedData[,2:87], by = list(subjectId=extractedData$subjectId,activities=extractedData$activities),mean)
```

Finally, we create a txt file with write.table() using row.names=FALSE for the submission.


```r
      write.table(tidyData, "~/coursera/repos/GetData_PA1/tidy_data.txt", row.names = FALSE)
```

