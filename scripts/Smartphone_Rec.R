
########################################
#
# 1 -> Download and unzip file in a folder 
# 2 -> In main_directory variable input the path of the main folder. 
#
########################################

# 1. Merges the training and the test sets to create one data set.

########################################

######################################
# LOADING LIBRARY
######################################

library(dplyr)

######################################
# LOADING TEST DATASET
######################################

#Loading main dirctory file path
# This is the directory where data set is unzipped.
# This must be change depending where the file is upload.

main_directory = file.path("UCIDataset")

test_dataset_dir = file.path(main_directory,"test")
train_dataset_dir = file.path(main_directory,"train")

#-----------------------
# Features
#-----------------------
# dim : 561 / 2
features <- read.table(file.path(main_directory,"features.txt"))

# features table contains duplicate names
# concatenate ID and Names in a new column to create unique name
# using duplicate names create issues
features <- tbl_df(features)
names(features) <- c("id","feature")
features <- mutate(features,unique_name = paste(feature,"-",id))



#-----------------------
# Test X
#-----------------------
# dim X : 2947 / 561
X_test <- read.table(file.path(test_dataset_dir,"X_test.txt"))


#-----------------------
# Train X
#-----------------------
# dim X : 7352 / 561
X_train <- read.table(file.path(train_dataset_dir,"X_train.txt"))


# dim : 10299 / 561
X_set <- bind_rows(X_test,X_train)

rm(X_test)
rm(X_train)


#-----------------------
# Test Y
#-----------------------
# dim : 2947 / 1
Y_test <- read.table(file.path(test_dataset_dir,"Y_test.txt"))


#-----------------------
# Train Y
#-----------------------
# dim : 7352 / 1
Y_train <- read.table(file.path(train_dataset_dir,"Y_train.txt"))

# dim : 10299 / 1
Y_set <- bind_rows(Y_test,Y_train)

rm(Y_test)
rm(Y_train)


#-----------------------
# subject_test
#-----------------------
# dim : 2947 / 1
subject_test <- read.table(file.path(test_dataset_dir,"subject_test.txt"))
subject_test <- tbl_df(subject_test)


#-----------------------
# subject_train
#-----------------------
# dim : 7352 / 1
subject_train <- read.table(file.path(train_dataset_dir,"subject_train.txt"))
subject_train <- tbl_df(subject_train)


# dim : 10299 / 1
subject_set <- bind_rows(subject_test,subject_train)

rm(subject_test)
rm(subject_train)


#-----------------------
# Bulding TEST DATASET
#-----------------------
dataset <- bind_cols(subject_set,Y_set,X_set)



########################################

# 4. Appropriately labels the data set with descriptive variable names.

########################################


# In order to do select step 4 is done before step 2.
names(dataset) <-  c("subject", "activity_code"  , as.character(features$unique_name))

 

########################################

# 2. Extracts only the measurements on the mean and standard deviation for each measurement

########################################


extract_mean_std <- select(dataset,contains("mean"),contains("std"))



########################################

# 3. Uses descriptive activity names to name the activities in the data set

########################################

# Load activites
# 1 WALKING
# 2 WALKING_UPSTAIRS
# 3 WALKING_DOWNSTAIRS
# 4 SITTING
# 5 STANDING
# 6 LAYING

#two separate tables 
# -- one containing activities ID and name
#-- and the other containing dataset with activities ID


activities <- read.table(file.path(main_directory,"activity_labels.txt"))
names(activities) <- c("activity_code","activity_name")

dataset <- merge(dataset, activities)[-1]
#activities



########################################

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

########################################

dataset_avg <- dataset %>% group_by(subject,activity_name)  %>% summarise_each(list(mean))



#
# END
#