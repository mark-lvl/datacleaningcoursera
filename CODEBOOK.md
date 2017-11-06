# Code Book

First of all, in order to become familiar with all the existing functions in the script, check out the README.md file, here we just discuss about the process of tidying the data and sequence of calling required functions and parameters.

The goal of this code book is to make the mentioned dataset in course project(Samsung dataset) tidy as requested in instructions and significantly Step.5 of it.

First off, we need to load and source the **run_analysis.R** script into your working directory:
 ```sh
> source('./run_analysis.R')
```

Here we can benefit from the **setup_env()** method which downloads the dataset from given URL and unpack it into a **./data** directory. For calling this function no parameter needed and the outcome of it will be a data directory which contains the unzip version of the dataset under the directory called, **"UCI HAR Dataset"**. The script will take care of the process of getting rid of junk file and we don't need to worry about the directory creation as well since it will be handled programmatically.
```sh
> setup_env()
```
For loading dataset in R, we use **Data.table** package which will be handled programmatically in case of package absence and it will be installed and loaded in working directory respectively.

The whole Dataset is junked into separate files in separate folders *(train and test)*, the first thing which we need to do is figuring out what are the data's features. Data features are listed in **features.txt** file in root of the dataset directory.

We'll read the dataset junks from **./data/train/X_train.txt** and **./data/test/X_test.txt** and their related activities and subjects which are located in:
 - "./data/train/subject_train.txt"
 - "./data/train/y_train.txt"

and

 - "./data/test/subject_test.txt"
 - "./data/test/y_test.txt"

and merge them all for each set column-based and the row-based for two main junks of data.

**NOTE:** In process of reading txt files into dataset we used the features list which was loaded in advance, in terms of naming the column titles.

All of above procedures is handled within the **merge_all_datasets()** function.
```sh
> samsung <- merge_all_datasets()
```

For naming the dataset features, some abbreviation was used in terms of making the list shorter but it had a negative effect on readability of data which we're trying to expand those abbreviations to their actual words and the meanwhile we'll updating the values of activity columns from activity codes into activity names, (e.g. 1 => 'WALKING', 2 => 'WALKING_UPSTAIRS' and so on). These value are stored in root of dataset directory **"activity_labels.txt"**. For doing what explained here we need to call two functions:
First, **descriptive_activity_value** which converts activity columns into more descriptive values:
```sh
> samsung <- descriptive_activity_value(samsung)
```
and second, **descriptive_labels** which unpack the label abbreviations.
```sh
> samsung <- descriptive_labels(samsung)
```

Note that, in both above methods we **overwrite** the result over the existing dataset.

As the latest step to achieve our tidy dataset we have to call **calculate_means** which gets the dataset as input and it groups the rows based on *Activity* and *Subject* and then leverage the lapply function in order to calculate the mean of any feature in dataset and finally it will save the outcome in a txt file format (**Tidy_dataset.txt**) as output in the same data directory :
```sh
> tidy_data <- calculate_means(samsung)
```
