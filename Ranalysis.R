
## Load libraries
library(dplyr)
library(tibble)
library(magrittr)

## Load data in

FeaturesData<-read.table("UCI HAR Dataset/features.txt",header=FALSE,sep="",quote="\"",dec=".",fill =TRUE,comment.char="",col.names =c("IDfeature","NAMEfeature"),stringsAsFactors=FALSE)

ActivityData<- read.table("UCI HAR Dataset/activity_labels.txt",header =FALSE,sep="",quote ="\"",dec =".",fill =TRUE, comment.char="",col.names=c("IDactivity","NAMEactivity"))




# Load data in and combine Train data

TrainActivities<-read.table("UCI HAR Dataset/train/Y_train.txt",header=FALSE,sep="",quote="\"",dec=".",fill=TRUE,comment.char="",col.names=c("IDactivity"))
TrainSub<-read.table("UCI HAR Dataset/train/subject_train.txt",header=FALSE,sep="",quote="\"",dec=".",fill =TRUE,comment.char="",col.names=c("IDsubject"))
TrainxDATA<-read.table("UCI HAR Dataset/train/X_train.txt",header=FALSE,sep="",quote="\"",dec=".",fill=TRUE,comment.char="",col.names=FeaturesData$NAMEfeature)
DatasetTrain<-tbl_df(cbind(TrainSub,TrainActivities,TrainxDATA))

##head(DatasetTrain)
## Load data in and combine Test Data

TestActivities<-read.table("UCI HAR Dataset/test/Y_test.txt",header=FALSE,sep="",quote="\"",dec=".",fill=TRUE,comment.char="",col.names=c("IDactivity"))
TestSub<-read.table("UCI HAR Dataset/test/subject_test.txt",header=FALSE,sep="",quote="\"",dec=".",fill =TRUE,comment.char="",col.names=c("IDsubject"))
TestxData<-read.table("UCI HAR Dataset/test/X_test.txt",header=FALSE,sep="",quote="\"",dec=".",fill=TRUE,comment.char="",col.names=FeaturesData$NAMEfeature)
DatasetTest<-tbl_df(cbind(TestSub,TestActivities,TestxData))

##head(DatasetTest)

## Combine data into single data set and change colom names

Data<-rbind(DatasetTrain,DatasetTest)
Data<-Data %>% inner_join(ActivityData)
Data<-Data %>% select(IDsubject,Nameactivity,contains("mean..",contains("std..")))
Data<-Data %>% setNames(gsub("^f","Domain Frequency",names(.)))
Data<-Data %>% setNames(gsub("^t","Domain Time",names(.)))

Data<- Data %>% setNames(gsub("Acc","Acceler Meter",names(.)))

Data<- Data %>% setNames(gsub("Gyro","Gyroscopes",names(.)))


Data<- Data %>% setNames(gsub("mean","Average/Mean",names(.)))

Data<- Data %>% setNames(gsub("std\\.\\.","Standers Deciation",names(.)))

Data<- Data %>% setNames(gsub("\\.","",names(.)))


Data<- Data %>% setNames(gsub("Mag","Magnitudes",names(.)))



##  Make a tidy data set and get mean of each variable and group tidy data set with Id subject

TidyData <- Data %>% group_by(IDsubject, NAMEactivity)
TidyData <- TidyData %>% summarize_all(funs(mean))

write.table(TidyData, file = "TidyDataset.txt", row.name = FALSE)




