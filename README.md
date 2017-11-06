# Readme

The manual of **run_analysis.R** script, Coursera Data cleaning course project.

After cloning the project repository the first step is sourcing the script into your working directory by running in **R**:
 ```sh
> source('./run_analysis.R')
```
Then, we have to call **setup_env()** without any parameter in order to download the Samsung dataset in current directory and unpack it. *(The function will take care of removing junk files)*.
```sh
> setup_env()
```
In terms of merging all the dataset fractions into a single dataset *(Step.1 in instruction)* we need to call the second method of run_analysis script which is: **merge_all_datasets**, again we don't need to pass any parameter to function. Simply call the below function and passing the return value to any desired variable name:
```sh
> samsung <- merge_all_datasets()
```

In order to filter dataset to columns in which calculated the mean or standard deviation *(Step.2 in instruction)*, we need to call **filter_mean_std_columns** function and it needs to get dataset as parameter. This function simply filters all the columns of the dataset by looking up for **"mean"** or **"std"** in their labels.
```sh
> filter_mean_std_columns(samsung)
```

There is a written function called **descriptive_activity_value** which can be used in order to alter the Activity column values to descriptive values *(Step.3 in instruction)*. We need to pass the dataset as input parameter and assign the function return value to the same dataset in order to alter the activity column values same as what demonstrated below:
```sh
> samsung <- descriptive_activity_value(samsung)
```

In the original dataset there are some columns which contain abbreviation for their names, in terms of unpack those abbreviation to more descriptive titles *(Step.4 in instruction)* we can call **descriptive_labels** function which gets the dataset as input and the returned value contains the columns with more descriptive titles.
```sh
> samsung <- descriptive_labels(samsung)
```

For making the tidy dataset as request in *(Step.5 in instruction)* we can utilise to power of data.table in R and just call the written function **calculate_means** which gets the dataset as input and returns the tidy dataset which contains means of features grouped by subjects and activities:
```sh
> tidy_data <- calculate_means(samsung)
```
