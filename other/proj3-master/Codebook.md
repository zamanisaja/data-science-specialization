In the first part it just checks if the data is already downloaded and if not, it downloads it.

Then I load the train data into a dataframe called df_features_train.
and the test data into a dataframe called df_features_test.
I repeat the same for activity labels and subject list.
Then I set the column names of the dataframes.
Then I merge the two dataframes using rbind command.
```
df <- rbind(df_features_train, df_features_test)
```

now with the grep command i look for the mean and standard deviation in the column names of dataframe df and subset the dataframe accordingly.

In part 3 I've added the labeled datas to the dataframe df.
and named each activity column with the activity name.

```
levels(df$activity) <- activities
```

Then I check if there are any missing values and drop them if needed.

```
df <- na.omit(df)
```

In the 4th part I rename the names and give them more descriptive names.

In the last part I group the dataframe by subject and activity and calculate their mean. 

And finally I save the dataframe to a text file.

```