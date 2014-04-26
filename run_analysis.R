## This project is based on the Davide Anguita, Alessandro Ghio, Luca Oneto, 
## Xavier Parra and Jorge L. Reyes-Ortiz publication 
## "Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine".
## International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

## This script merges data from a number of .txt files and produces 
## a tidy data set which may be used for further analysis.

##check for required packages
if (!("reshape2" %in% rownames(installed.packages())) ) {
  print("Please install required package \"reshape2\" before proceeding")
} else {
        ## Open required libraries
        library(reshape2)

        ## First, read all required .txt files and label the datasets
        
        ## Read all activities and their names and label the aproppriate columns 
        activity_labels <- read.table("./activity_labels.txt",col.names=c("activity_id","activity_name"))

        ## Read the dataframe's column names
        features <- read.table("features.txt")
        feature_names <-  features[,2]
        
        ## Read the test data and label the dataframe's columns
        testdata <- read.table("./test/X_test.txt")
        colnames(testdata) <- feature_names
        
        ## Read the training data and label the dataframe's columns
        traindata <- read.table("./train/X_train.txt")
        colnames(traindata) <- feature_names
        
        ## Read the ids of the test subjects and label the the dataframe's columns
        test_subject_id <- read.table("./test/subject_test.txt")
        colnames(test_subject_id) <- "subject_id"
        
        ## Read the activity id's of the test data and label the the dataframe's columns
        test_activity_id <- read.table("./test/y_test.txt")
        colnames(test_activity_id) <- "activity_id"
        
        ## Read the ids of the test subjects and label the the dataframe's columns
        train_subject_id <- read.table("./train/subject_train.txt")
        colnames(train_subject_id) <- "subject_id"
        
        ## Read the activity id's of the training data and label 
        ##the dataframe's columns
        train_activity_id <- read.table("./train/y_train.txt")
        colnames(train_activity_id) <- "activity_id"
        
        ##Combine the test subject id's, the test activity id's 
        ##and the test data into one dataframe
        test_data <- cbind(test_subject_id , test_activity_id , testdata)
        
        ##Combine the test subject id's, the test activity id's 
        ##and the test data into one dataframe
        train_data <- cbind(train_subject_id , train_activity_id , traindata)
        
        ##Combine the test data and the train data into one dataframe
        all_data <- rbind(train_data,test_data)
        
        ##Keep only columns refering to mean() or std() values
        mean_col_idx <- grep("mean",names(all_data),ignore.case=TRUE)
        mean_col_names <- names(all_data)[mean_col_idx]
        std_col_idx <- grep("std",names(all_data),ignore.case=TRUE)
        std_col_names <- names(all_data)[std_col_idx]
        meanstddata <-all_data[,c("subject_id","activity_id",mean_col_names,std_col_names)]
        
        ##Merge the activities datase with the mean/std values datase 
        ##to get one dataset with descriptive activity names
        descrnames <- merge(activity_labels,meanstddata,by.x="activity_id",by.y="activity_id",all=TRUE)
        
        ##Melt the dataset with the descriptive activity names for better handling
        data_melt <- melt(descrnames,id=c("activity_id","activity_name","subject_id"))
        
        ##Cast the melted dataset according to  the average of each variable 
        ##for each activity and each subjec
        mean_data <- dcast(data_melt,activity_id + activity_name + subject_id ~ variable,mean)
       
        ## Create a file with the new tidy dataset
        write.table(mean_data,"./tidy_movement_data.txt")

}