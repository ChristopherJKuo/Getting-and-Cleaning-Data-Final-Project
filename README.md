# Getting-and-Cleaning-Data-Final-Project

The script reads the test and training files into separately.
They are combined and the labels are substituted with the numeric values using the text in the activity_labels.txt file.

The numbers from the set are extracted using an alphanumeric regex.
Extracted list is transformed into a dataframe using matrix, unlist, and setting the column length
The names for the variables are taken from features.txt.

The mean and std variables are found using grep and mean | std.
The mean and std variables are then combined with the labels and subject variables.

The average.dataset is made by grouping by labels and subject and using summarize_each
