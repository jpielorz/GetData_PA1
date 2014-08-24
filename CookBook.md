---
title: "CookBook"
author: "jip"
date: '2014-08-23'
output: html_document
---

## Data Source

For this course work the raw data can be downloaded here: 

<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

A full description of how it was obtained is available at the site where the data was obtained:

<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

For more information about this dataset contact: activityrecognition@smartlab.ws

## Reference

Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

## Original Dataset Information

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

## Tidy Dataset Summary

From the original dataset a new dataset "tidy_data.txt"" was created by applying the run_analysis.R script. A detailed description of how it was obtained can be found in README.md.

## Description of the tidy dataset

The tidy dataset consists of averages of each variable that contained mean and standard deviation in its name for each activity and each subject. Since there were 6 different possible activities and 30 different subjects, the resulting dataset contains 180 different rows. The number of columns is 88 due 86 different feature variables with mean and standard deviations in addition to one subjectId and one activity column.



```r
      tidy_data <- read.table("~/coursera//repos/GetData_PA1/tidy_data.txt", header = TRUE)
      dim(tidy_data)
```

```
## [1] 180  88
```

The complete list of variable names is


```r
      names(tidy_data)
```

```
##  [1] "subjectId"                          
##  [2] "activities"                         
##  [3] "tBodyAcc_mean_X"                    
##  [4] "tBodyAcc_mean_Y"                    
##  [5] "tBodyAcc_mean_Z"                    
##  [6] "tBodyAcc_std_X"                     
##  [7] "tBodyAcc_std_Y"                     
##  [8] "tBodyAcc_std_Z"                     
##  [9] "tGravityAcc_mean_X"                 
## [10] "tGravityAcc_mean_Y"                 
## [11] "tGravityAcc_mean_Z"                 
## [12] "tGravityAcc_std_X"                  
## [13] "tGravityAcc_std_Y"                  
## [14] "tGravityAcc_std_Z"                  
## [15] "tBodyAccJerk_mean_X"                
## [16] "tBodyAccJerk_mean_Y"                
## [17] "tBodyAccJerk_mean_Z"                
## [18] "tBodyAccJerk_std_X"                 
## [19] "tBodyAccJerk_std_Y"                 
## [20] "tBodyAccJerk_std_Z"                 
## [21] "tBodyGyro_mean_X"                   
## [22] "tBodyGyro_mean_Y"                   
## [23] "tBodyGyro_mean_Z"                   
## [24] "tBodyGyro_std_X"                    
## [25] "tBodyGyro_std_Y"                    
## [26] "tBodyGyro_std_Z"                    
## [27] "tBodyGyroJerk_mean_X"               
## [28] "tBodyGyroJerk_mean_Y"               
## [29] "tBodyGyroJerk_mean_Z"               
## [30] "tBodyGyroJerk_std_X"                
## [31] "tBodyGyroJerk_std_Y"                
## [32] "tBodyGyroJerk_std_Z"                
## [33] "tBodyAccMag_mean"                   
## [34] "tBodyAccMag_std"                    
## [35] "tGravityAccMag_mean"                
## [36] "tGravityAccMag_std"                 
## [37] "tBodyAccJerkMag_mean"               
## [38] "tBodyAccJerkMag_std"                
## [39] "tBodyGyroMag_mean"                  
## [40] "tBodyGyroMag_std"                   
## [41] "tBodyGyroJerkMag_mean"              
## [42] "tBodyGyroJerkMag_std"               
## [43] "fBodyAcc_mean_X"                    
## [44] "fBodyAcc_mean_Y"                    
## [45] "fBodyAcc_mean_Z"                    
## [46] "fBodyAcc_std_X"                     
## [47] "fBodyAcc_std_Y"                     
## [48] "fBodyAcc_std_Z"                     
## [49] "fBodyAcc_meanFreq_X"                
## [50] "fBodyAcc_meanFreq_Y"                
## [51] "fBodyAcc_meanFreq_Z"                
## [52] "fBodyAccJerk_mean_X"                
## [53] "fBodyAccJerk_mean_Y"                
## [54] "fBodyAccJerk_mean_Z"                
## [55] "fBodyAccJerk_std_X"                 
## [56] "fBodyAccJerk_std_Y"                 
## [57] "fBodyAccJerk_std_Z"                 
## [58] "fBodyAccJerk_meanFreq_X"            
## [59] "fBodyAccJerk_meanFreq_Y"            
## [60] "fBodyAccJerk_meanFreq_Z"            
## [61] "fBodyGyro_mean_X"                   
## [62] "fBodyGyro_mean_Y"                   
## [63] "fBodyGyro_mean_Z"                   
## [64] "fBodyGyro_std_X"                    
## [65] "fBodyGyro_std_Y"                    
## [66] "fBodyGyro_std_Z"                    
## [67] "fBodyGyro_meanFreq_X"               
## [68] "fBodyGyro_meanFreq_Y"               
## [69] "fBodyGyro_meanFreq_Z"               
## [70] "fBodyAccMag_mean"                   
## [71] "fBodyAccMag_std"                    
## [72] "fBodyAccMag_meanFreq"               
## [73] "fBodyBodyAccJerkMag_mean"           
## [74] "fBodyBodyAccJerkMag_std"            
## [75] "fBodyBodyAccJerkMag_meanFreq"       
## [76] "fBodyBodyGyroMag_mean"              
## [77] "fBodyBodyGyroMag_std"               
## [78] "fBodyBodyGyroMag_meanFreq"          
## [79] "fBodyBodyGyroJerkMag_mean"          
## [80] "fBodyBodyGyroJerkMag_std"           
## [81] "fBodyBodyGyroJerkMag_meanFreq"      
## [82] "angle_tBodyAccMean_gravity"         
## [83] "angle_tBodyAccJerkMean_gravityMean" 
## [84] "angle_tBodyGyroMean_gravityMean"    
## [85] "angle_tBodyGyroJerkMean_gravityMean"
## [86] "angle_X_gravityMean"                
## [87] "angle_Y_gravityMean"                
## [88] "angle_Z_gravityMean"
```


The first variable is subjectId and consists of integers from 1 to 30. The second variable holds activities with the following levels:


```r
      levels(tidy_data$activities)
```

```
## [1] "LAYING"             "SITTING"            "STANDING"          
## [4] "WALKING"            "WALKING_DOWNSTAIRS" "WALKING_UPSTAIRS"
```

All other variables are averages for a given subject and activity. Details on the original variables and how they were obtained can be found in "feature_info.txt".
