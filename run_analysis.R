#Step1:Merges the training and the test sets to create one data set.

#read in test data
data.test.x<-read.table("./UCI HAR Dataset/test/X_test.txt")
data.test.y<-read.table("./UCI HAR Dataset/test/Y_test.txt")
colnames(data.test.y)<-c("activity")
data.test.sub<-read.table("./UCI HAR Dataset/test/subject_test.txt")
colnames(data.test.sub)<-c("subject")
data.test<-cbind(data.test.x,data.test.y,data.test.sub)

#read in train data
data.train.x<-read.table("./UCI HAR Dataset/train/X_train.txt")
data.train.y<-read.table("./UCI HAR Dataset/train/Y_train.txt")
colnames(data.train.y)<-c("activity")
data.train.sub<-read.table("./UCI HAR Dataset/train/subject_train.txt")
colnames(data.train.sub)<-c("subject")
data.train<-cbind(data.train.x,data.train.y,data.train.sub)

#merge the data into one table
data<-rbind(data.test,data.train)

#Step2:Extracts only the measurements on the mean and standard 
#deviation for each measurement.

#find out the labels for the mean and standard deviation
measurement<-read.table("./UCI HAR Dataset/features.txt")
meanstd<-grep("mean|std|Mean",measurement$V2)

#extract the mean and std measurements from the data table
datameanstd<-cbind(data[,meanstd],data$activity,data$subject)

#mach the measurement to their names
names<-as.character(measurement[meanstd,]$V2)
colnames(datameanstd)<-c(names,"activity","subject")


#Step3:Uses descriptive activity names to name the activities 
#in the data set

#read in activity names
activity<-read.table("./UCI HAR Dataset/activity_labels.txt")
colnames(activity)<-c("lable","activity")
mergedata<-merge(activity,datameanstd,by.y="activity",by.x="lable",all=TRUE)

#Step4 Appropriately labels the data set with descriptive variable names. 
#This has been done in step2 when I select out the mean and std measurements.


#Step5 From the data set in step 4, creates a second, independent tidy data set 
#with the average of each variable for each activity and each subject.

install.packages("reshape")
library("reshape")

cname<-names(mergedata)
mnames<-cname[-c(89,1,2)]

data<-melt(mergedata,id.vars<-c("lable","activity","subject"),measure.vars<-mnames)
library(plyr)
cdata<-ddply(data,.(activity,subject,variable),summarize,average=mean(value))

#####Write out the data set.
write.table(cdata,row.name=FALSE,file="./Course3Project.txt")


