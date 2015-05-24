library(plyr) 
library(reshape2)

subject_test <- read.table("./data/test/subject_test.txt", col.names=c("Subject"))
subject_train <- read.table("./data/train/subject_train.txt", col.names=c("Subject"))
subject_data <- rbind(subject_train, subject_test)

x_test <- read.table("./data/test/X_test.txt")
x_train <- read.table("./data/train/X_train.txt")
x_data <- rbind(x_test, x_train)

features <- read.table("./data/features.txt", col.names=c("index", "feature_labels"))
feature_labels <- features$feature_labels
features_subset <- grepl('mean\\(\\)|std\\(\\)',feature_labels)
features <- as.character(feature_labels[features_subset])

 
colnames(x_data) <- feature_labels
x_data <- x_data[,features_subset]


y_test <- read.table("./data/test/Y_test.txt")
y_train <- read.table("./data/train/Y_train.txt")
y_data <- rbind(y_test, y_train)
colnames(y_data) <- "activityLabel"

activity_labels<-read.table("./data/activity_labels.txt",sep=" ",col.names=c("activityLabel","Activity"))
y_data<-join(y_data,activity_labels,by="activityLabel",type="left")
y_data$activityLabel <- NULL


all_data <- cbind(x_data, y_data, subject_data)


dataframe <- melt(all_data, id=c("Subject", "Activity"), measure.vars=features)
dataframe <- dcast(dataframe, Activity + Subject ~ variable, mean)
dataframe <- dataframe[order(dataframe$Subject, dataframe$Activity),]

rownames(dataframe) <- 1:nrow(dataframe)
dataframe <- dataframe[,c(2,1,3:68)]

write.table(dataframe,file="dataset.txt") 
