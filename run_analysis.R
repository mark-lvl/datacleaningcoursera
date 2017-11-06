setup_env <- function () {
    ## Create data directory to keep all dataset files in the same folder.
    if (!dir.exists("./data")) {dir.create("./data")}
    
    URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    
    download.file(URL,destfile = "./data/temp.zip")
    unzip(zipfile = "./data/temp.zip", exdir = "./data/")
    
    ## Unlink unneccesary file
    unlink("./data/temp.zip")
}

merge_all_datasets <- function () {
    
    ## Check the existence of data.table library and install it in case of missing.
    list.of.packages <- c("data.table")
    new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
    if(length(new.packages)) install.packages(new.packages)
    
    ## Load the data.table package
    library(data.table)
    
    ## Change the working directory to data directory in order to load data files easily 
    if(!grepl("./data/UCI HAR Dataset", getwd())) {
        setwd("./data/UCI HAR Dataset")    
    }
    
    ## Load features labels for dataset
    features <- fread("features.txt")
    
    subject_train <- fread("train/subject_train.txt", col.names = "Subject")
    activity_train <- fread("train/y_train.txt", col.names = "Activity")
    
    train <- fread("train/X_train.txt", col.names = features$V2)
    
    train_df <- cbind(subject_train, activity_train, train)
    
    
    subject_test <- fread("test/subject_test.txt", col.names = "Subject")
    activity_test <- fread("test/y_test.txt", col.names = "Activity")
    
    test <- fread("test/X_test.txt", col.names = features$V2)
    
    test_df <- cbind(subject_test, activity_test, test)
    
    rbind(train_df, test_df)
}

filter_mean_std_columns <- function(dt) {
    dt[,grep('^Activity$|^Subject$|mean|std',names(dt)), with=FALSE]
}

descriptive_activity_value <- function(dt) {
    ## Reading the activity labels from the original dataset.
    activity_labels <- fread("activity_labels.txt")
    activity_labels <- as.character(activity_labels$V2)
    
    dt$Activity <- activity_labels[dt$Activity]
    dt
}

descriptive_labels <- function(dt) {
    label_names <- names(dt)
    label_names <- gsub("^[t]BodyAcc", "TriaxialBodyAcceleration",label_names)
    label_names <- gsub("^[t]GravityAcc", "TriaxialGravityAcceleration",label_names)
    label_names <- gsub("^[t]BodyGyro", "TriaxialGyroscope",label_names)
    label_names <- gsub("^[f]BodyAcc", "FeatureBodyAcceleration",label_names)
    label_names <- gsub("^[f]BodyGyro", "FeatureBodyGyroscope",label_names)
    label_names <- gsub("^[f]BodyBodyGyro", "FeatureBodyBodyGyroscope",label_names)
    label_names <- gsub("^[f]BodyBodyAcc", "FeatureBodyBodyAcceleration",label_names)
    names(dt) <- label_names
    dt
}

calculate_means <- function(dt) {
    means <- dt[, lapply(.SD, mean), by = c('Activity', 'Subject')]
    write.table(means, file = "./Tidy_dataset.txt", row.name=FALSE)
    means
}