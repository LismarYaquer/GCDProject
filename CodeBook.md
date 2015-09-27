# Human Activity Recognition Using Smartphones Dataset

This is a slightly modified version of the Human Activity Recognition Using Smartphones Dataset. Created in order to acomplish the Getting and Cleaning Data Project.

Description of the dataset:
Contains four (4) variables indicating the mean values of the mean or standard deviation for each feature, grouped by subject, activity and feature.

Variables:
	subject_id:	integer
				Indicates the id number of each participant.
				Values: From 1 to 30.

	activity:	factor
				Label indicating the activity performed by the participant.
				Values: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, LAYING.

	feature:	factor
				Holds the name of the feature measured.
				Values: Extracted from features.txt file contained in the original Dataset. Were selected only those were the measure used were 'mean' or 'std'.

	mean_value: double
				Indicates the mean value of a large number of observations for each feature, activity and subject.
				Values: In the interval [-1, 1].

Steps:
1. Select from features.txt only those features were used 'mean' or 'std' as a measure. Hold their indexes in a variable.
2. For both training and test dataset do:
	1. Select from the dataset only those variable were used 'mean' or 'std' as a measure. Use indexes from (1.) to accomplish this. 
	2. Use activity_labels.txt and y_[dataset].txt to put appropriate label names for activities.
	3. Load the subject's ids into a variable using subject_[dataset].txt.
3. Join together subject's ids, activity labels and the dataset containing the variable were used 'mean' or 'std' as a measure.
4. Use gather function from tidyr package as follows:
	data_from_4 <- gather( data_from_3 , key = feature, value = value, -c(subjects_ids, activity_labels))
	this way there will be 4 variables where 2 of them are feature and value.
5. Use group_by function from dplyr package to create groups according to the subject's id, the activity and the feature. Calculate the means of each group using summarize function from dplyr package.
