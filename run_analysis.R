
#Downloading data

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile = "./Dataset.zip")

#unziping the file
unzip("Dataset.zip",exdir = "./week4")

# unzipped files are in the folder UCI HAR Dataset. Seeing the list of all files
path<- 'C:/Users/Zohra/Desktop/R/week4/UCI HAR Dataset'
FileList <- list.files(path,pattern=NULL )
FileList

#assigning all dataframe

features <- read.table("./week4/UCI HAR Dataset/features.txt",col.names = c("id","function"))

activites <- read.table("./week4/UCI HAR Dataset/activity_labels.txt",col.names = c("code","activity"))

subject_test <- read.table("./week4/UCI HAR Dataset/test/subject_test.txt",col.names="subject"   )                 

x_test <- read.table("./week4/UCI HAR Dataset/test/X_test.txt", col.names = features$function.)

y_test <- y_test <- read.table("./week4/UCI HAR Dataset/test/y_test.txt", col.names = "code")

subject_train <- read.table("/week4/UCI HAR Dataset/train/subject_train.txt",col.names = "subject")

x_train <- read.table("/week4/UCI HAR Dataset/train/X_train.txt",col.names = features$function.)

y_train <- read.table("/week4/UCI HAR Dataset/train/y_train.txt",col.names="code")

#1: Merges the training and the test sets to create one data set.

X<- rbind(x_test,x_train)
Y <- rbind(y_test,y_train)
subject <- rbind(subject_test,subject_train)
Merge_data <- cbind(X,Y,subject)
View(head(Merge_data))

library(dplyr)
#2: Extracts only the measurements on the mean and standard deviation for each measurement.
TidyData <- Merge_data %>% select(subject, code, contains("mean"), contains("std"))

#3: Uses descriptive activity names to name the activities in the data set.
TidyData$code <- activites[TidyData$code, 2]
#4:Appropriately labels the data set with descriptive variable names.

names(TidyData)[2] = "activity"
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))

# 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

FinalData <- TidyData %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)
str(FinalData)
