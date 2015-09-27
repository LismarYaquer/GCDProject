## Lismar Martin's Solution to Getting and Cleaning Data Project

## requiring packages
require(dplyr)
require(tidyr)

## reading features
features <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors = F)
names(features) <- c("feat_id", "feat_name")

## select those features were used 'mean' and 'std' as a measure
means <- grep(pattern = "mean()",
              x = features$feat_name,
              fixed = T)
stds <- grep(pattern = "std()",
             x = features$feat_name,
             fixed = T)
measures <- sort(union(means, stds))
remove(list = c("means", "stds"))

## reading activities
activities <- read.table("UCI HAR Dataset/activity_labels.txt")
names(activities) <- c("id", "label")

## reading training data
training_set <- read.table("UCI HAR Dataset/train/X_train.txt")
    names(training_set) <- features$feat_name
training_set <- subset(training_set, select = measures)

training_labels <- read.table(file = "UCI HAR Dataset/train/y_train.txt")
    names(training_labels) <- "id"
training_labels <- inner_join(x = activities,
                              y = training_labels,
                              copy = F) %>% select(activity = label)

training_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
    names(training_subjects) <- "subject_id"

training_set <- tbl_df(cbind(training_subjects, training_labels, training_set))
remove(list = c("training_labels","training_subjects"))

## reading test data
test_set <- read.table(file = "UCI HAR Dataset/test/X_test.txt")
    names(test_set) <- features$feat_name
test_set <- subset(test_set, select = measures)

test_labels <- read.table("UCI HAR Dataset/test/y_test.txt")
    names(test_labels) <- "id"
test_labels <- inner_join(x = activities,
                          y = test_labels,
                          copy = F) %>% select(activity = label)

test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
    names(test_subjects) <- "subject_id"

test_set <- tbl_df(cbind(test_subjects, test_labels, test_set))
remove(list = c("test_subjects", "test_labels", "features", "measures", "activities"))


# Merging Datasets
raw_data <- bind_rows(training_set, test_set)
rm(list = c("training_set", "test_set"))

# Tidying Dataset
raw_data <- gather(raw_data, key = feature, value = value, -c(subject_id, activity))
tidy_data <- raw_data %>%
    group_by(subject_id, activity, feature) %>%
    summarize(mean_value =  mean(value))

# Saving Tidy dataset
write.table(x = tidy_data, file = "HARUSD-v2.txt", row.name = F)
