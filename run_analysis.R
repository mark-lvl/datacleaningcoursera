setup_env <- function () {
    if (!dir.exists("./data")) {dir.create("./data")}
    
    URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    temporaryFile <- tempfile()
    download.file(URL,destfile = "./data/temp.zip")
    unzip(zipfile = "./data/temp.zip", exdir = "./data/")
    unlink("./data/temp.zip")
}

merge_all_datasets <- function () {
    library(data.table)
    if(!grepl("./data/UCI HAR Dataset", getwd())) {
        setwd("./data/UCI HAR Dataset")    
    }
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

extract_mean_std_columns <- function(dt) {
    dt[,grep('mean|std',names(dt)), with=FALSE]
}

descriptive_activity_value <- function(dt) {
    activity_labels <- c('WALKING','WALKING_UPSTAIRS','WALKING_DOWNSTAIRS','SITTING','STANDING','LAYING')

    dt$Activity <- activity_labels[df$Activity]
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