library(reshape2)

file_name <- "getdata_dataset.zip"

#downloading and  unzipping the dataset
if(!file.exists(file_name))
{
  url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(url,file_name)
}

if (!file.exists("UCI HAR Dataset"))
{ 
  unzip(file_name)
}

setwd("./getdata_dataset/UCI HAR Dataset/")




#reading the activities viz walking,running,...
activitylabel <- read.table("./activity_labels.txt")
activitylabel[,2] <- as.character(activitylabel[,2])

#reading the features viz measurements
features <- read.table("./features.txt")
features[,2] <- as.character(features[,2])

#seperate the mean and the standard deviation measurements
featuresrequired <- grep(".*mean.*|.*std.*",features[,2])
featuresrequirednames <- features[featuresrequired,2]

#label the names properly
featuresrequirednames = gsub("-mean","Mean",featuresrequirednames)
featuresrequirednames = gsub("-std","Std",featuresrequirednames)
featuresrequirednames = gsub("[-()]","",featuresrequirednames)


#reading the training set subset by the measurements
train <- read.table("./train/X_train.txt")[featuresrequired]
trainactivities <- read.table("./train/y_train.txt")
trainsubjects <- read.table("./train/subject_train.txt")
train <- cbind(trainsubjects,trainactivities,train)

#reading the testing set subset by the measurements
test <- read.table("./test/X_test.txt")[featuresrequired]
testactivities <- read.table("./test/y_test.txt")
testsubjects <- read.table("./test/subject_test.txt")
test <- cbind(testsubjects,testactivities,test)

#Combining both the datasets
data <- rbind(train,test)
colnames(data) <- c("subject","activity",featuresrequirednames)

#converting subject and activity into factors 
data$subject <- as.factor(data$subject)
data$activity <- factor(data$activity,levels=activitylabel[,1],labels = activitylabel[,2])

#grouping and ordering by subject the means of the measurements.
data_melted <- melt(data,id=c("subject","activity"))
data_mean <- dcast(data_melted,subject+activity~variable,mean)

write.table(data_mean,"tidydata.txt",row.names = F,quote = F)



