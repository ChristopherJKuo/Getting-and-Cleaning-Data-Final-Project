run_analysis <- function(){
    require(dplyr)
    require(stringr)
    #read in the files fromo the UCI HAR Dataset level
    
    test <- read.csv("./test/y_test.txt", header=FALSE, stringsAsFactors = FALSE)
    test.set <- read.csv("./test/X_test.txt", header = FALSE, stringsAsFactors = FALSE)
    test.subject <- read.csv("./test/subject_test.txt", header=FALSE, stringsAsFactors = FALSE)
    train <- read.csv("./train/y_train.txt", header=FALSE, stringsAsFactors = FALSE)
    train.set <- read.csv("./train/X_train.txt", header = FALSE, stringsAsFactors = FALSE)
    train.subject <- read.csv("./train/subject_train.txt", header = FALSE, stringsAsFactors = FALSE)
    features <- read.csv("features.txt", header = FALSE, sep = " ")
    test$V2 <- test.set$V1
    test$V3 <- test.subject$V1
    train$V2 <- train.set$V1
    train$V3 <- train.subject$V1
    
    #name the columns in the dataframe and combined
    cname <- c("labels", "set", "subject")
    names(test) <- cname
    names(train) <- cname
    combined <- rbind(test,train)
    
    #appropriately change labels to descriptive variables
    combined$labels[which(combined$labels == 1)] <- "WALKING"
    combined$labels[which(combined$labels == 2)] <- "WALKING_UPSTAIRS"
    combined$labels[which(combined$labels == 3)] <- "WALKING_DOWNSTAIRS"
    combined$labels[which(combined$labels == 4)] <- "SITTING"
    combined$labels[which(combined$labels == 5)] <- "STANDING"
    combined$labels[which(combined$labels == 6)] <- "LAYING"
    
    #split the set into distinct variables
    setsplit <- str_extract_all(combined$set, "[A-Za-z0-9.+-]+")
    dfsetsplit <- as.data.frame(matrix(unlist(setsplit), ncol=length(unlist(setsplit[1]))), stringsAsFactors = FALSE)
    
    #name all of the variables from the variable list
    names(dfsetsplit) <- features$V2
    
    #take the only the columns with mean() and std() in them
    #combined them with the original list, remove the set variables
    meanandstd <-dfsetsplit[,grepl("(mean\\(\\)|std\\(\\))", names(dfsetsplit))]
    meanandstd[,1:66] <- lapply(meanandstd[,1:66], as.double)
    combined2 <- cbind(combined, meanandstd)
    combined2$set <- NULL
    combined2$setsplit <- NULL
    grouped <- group_by(combined2, labels, subject)
    summarized <- summarize_each(grouped, funs(mean))
}
