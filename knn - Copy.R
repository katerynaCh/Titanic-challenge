library (class)
library(dplyr)
library(lubridate)
library(gmodels)
library(ggvis)
library(RWeka)
library(kernlab)
library(randomForest)
library(e1071)
library(mice)
require(stringr)

MyData <- read.csv(file="C:\\Users\\Kateryna\\Desktop\\kaggle\\titanic\\train.csv", header=TRUE, sep=",", stringsAsFactors = FALSE)
TestData <- read.csv(file="C:\\Users\\Kateryna\\Desktop\\kaggle\\titanic\\test.csv", header=TRUE, sep=",", stringsAsFactors = FALSE)

#function of imputing mean value
impute.mean <- function (impute_col, filter_var, var_levels) {
        for (lev in var_levels) { 
                impute_col[(filter_var == lev) & is.na(impute_col)] <-
                        mean(impute_col[filter_var == lev], na.rm = T)
        }
        return (impute_col)
}

#function of title change
change.titles <- function(data, old_title, new_title) {
  for (title in old_title) {
    data$Title[data$Title == title] <- new_title
  }
  return (data$Title)
}

#replace strings with numbers in MyData
for(i in 1:nrow(MyData)){
  if (MyData[i,5] == "female") {
    MyData[i,5]=1 #girlpower
    MyData[i,5]=as.numeric((MyData[i,5]))
  }
  if (MyData[i,5] == "male") {
    MyData[i,5]=0
    MyData[i,5]=as.numeric(as.character(MyData[i,5]))
  }
  if (MyData[i,12] == "C") {
    MyData[i,12] = 1
    MyData[i,12] = as.numeric(as.numeric(MyData[i,12]))
  }
  if (MyData[i,12] == "Q") {
    MyData[i,12] = 2
    MyData[i,12] = as.numeric(as.numeric(MyData[i,12]))
  }
  if (MyData[i,12] == "S") {
    MyData[i,12] = 3
    MyData[i,12] = as.numeric(as.numeric(MyData[i,12]))
  }
  if (MyData[i,12] == "") {
    ##replace NAs with Southhampton, as it is the most popular location
    MyData[i,12] = 3
    MyData[i,12] = as.numeric(as.numeric(MyData[i,12]))
  }
  if (startsWith(MyData[i,11], "A")) {
    MyData[i,11] = 1
  }
  if (startsWith(MyData[i,11], "B")) {
    MyData[i,11] = 2
  }
  if (startsWith(MyData[i,11], "C")) {
    MyData[i,11] = 3
  }
  if (startsWith(MyData[i,11], "D")) {
    MyData[i,11] = 4
  }
  if (startsWith(MyData[i,11], "E")) {
    MyData[i,11] = 5
  }
  if (startsWith(MyData[i,11], "F")) {
    MyData[i,11] = 6
  }
  if (startsWith(MyData[i,11], "G")) {
    MyData[i,11] = 7
  }
  if (startsWith(MyData[i,11], "T")) {
    MyData[i,11] = 8
  }
  if (MyData[i,11]=="") {
    MyData[i,11] = NA
  }
}

#replace strings with numerics in TestData
for(i in 1:nrow(TestData)){
  if (TestData[i,4] == "female") {
    TestData[i,4]=1
    TestData[i,4]=as.numeric(TestData[i,4])
  }
  if (TestData[i,4] == "male") {
    TestData[i,4]=0
    TestData[i,4]=as.numeric(TestData[i,4])
  }
  if (TestData[i,11] == "C") {
    TestData[i,11] = 1
  }
  if (TestData[i,11] == "Q") {
    TestData[i,11] = 2
  }
  if (TestData[i,11] == "S") {
    TestData[i,11] = 3
  }
  if (TestData[i,11] == "") {
    TestData[i,11] = 3
    #replace NAs with Southhampton, as it is the most popular location
    TestData[i,11] = as.numeric(as.numeric(MyData[i,12]))
  }
  if (startsWith(TestData[i,10], "A")) {
    TestData[i,10] = 1
  }
  if (startsWith(TestData[i,10], "B")) {
    TestData[i,10] = 2
  }
  if (startsWith(TestData[i,10], "C")) {
    TestData[i,10] = 3
  }
  if (startsWith(TestData[i,10], "D")) {
    TestData[i,10] = 4
  }
  if (startsWith(TestData[i,10], "E")) {
    TestData[i,10] = 5
  }
  if (startsWith(TestData[i,10], "F")) {
    TestData[i,10] = 6
  }
  if (startsWith(TestData[i,10], "G")) {
    TestData[i,10] = 7
  }
  if (startsWith(TestData[i,10], "T")) {
    TestData[i,10] = 8
  }
  if (TestData[i,10]== "") {
    TestData[i,10] = NA
  }
}

#imputing missing Age values for the mean value of the appropriate Title.
#It was checked previously that they are present only in Dr, Master, Mrs, Miss, Mr titles.
MyData$Title <-  MyData$Name %>% str_extract(., "\\w+\\.") %>% str_sub(.,1, -2)
MyData$Age <- impute.mean(MyData$Age, MyData$Title, c("Dr", "Master", "Mrs", "Miss", "Mr"))

TestData$Title <-  TestData$Name %>% str_extract(., "\\w+\\.") %>% str_sub(.,1, -2)
TestData$Age <- impute.mean(TestData$Age, TestData$Title, c("Dr", "Master", "Mrs", "Miss", "Mr"))

# #imputing 0 Fare values with the mean value of the Class
MyData$Fare[MyData$Fare==0]<-NA
MyData$Fare <- impute.mean(MyData$Fare, MyData$Pclass, as.numeric((MyData$Pclass)))

TestData$Fare[TestData$Fare==0]<-NA
TestData$Fare <- impute.mean(TestData$Fare, TestData$Pclass, as.numeric((TestData$Pclass)))


# MyData$Fare <- impute.mean(MyData$Fare, MyData$Pclass, as.numeric(levels(MyData$Pclass)))


#grouping titles to Mr, Miss, Mrs, Master, Aristocratic (=1,2,3,4,5)
MyData$Title <- change.titles(MyData, 
                               c("Capt", "Col", "Don", "Dr", 
                               "Jonkheer", "Lady", "Major", 
                               "Rev", "Sir", "Countess"),
                               "Aristocratic")
MyData$Title <- change.titles(MyData, c("Ms", "Mrs"), 
                               4)
MyData$Title <- change.titles(MyData, c("Mlle", "Mme", "Miss"), 2)
MyData$Title <- change.titles(MyData, c("Mr"), 1)
MyData$Title <- change.titles(MyData, c("Master"), 3)
MyData$Title <- change.titles(MyData, c("Aristocratic"), 5)

TestData$Title <- change.titles(TestData, 
                              c("Capt", "Col", "Don", "Dr", 
                                "Jonkheer", "Lady", "Major", 
                                "Rev", "Sir", "Countess"),
                              "Aristocratic")
TestData$Title <- change.titles(TestData, c("Ms", "Mrs"), 
                              4)
TestData$Title <- change.titles(TestData, c("Mlle", "Mme", "Miss"), 2)
TestData$Title <- change.titles(TestData, c("Mr"), 1)
TestData$Title <- change.titles(TestData, c("Master"), 3)
TestData$Title <- change.titles(TestData, c("Aristocratic"), 5)




MyData<-MyData[,-c(1,4,9,11)]
TestData <- TestData[,-c(1,3,8,10)]

#imputed_Data <- amelia(MyData, m=5)

MyData$Sex<-as.numeric(MyData$Sex)
TestData$Sex<-as.numeric(TestData$Sex)
MyData$Embarked<-as.numeric(MyData$Embarked)
TestData$Embarked<-as.numeric(TestData$Embarked)
MyData$Title<-as.numeric(MyData$Title)
TestData$Title<-as.numeric(TestData$Title)

coln = ncol(MyData)
set.seed(1234)
#label matrix with 1 with prob 0.065 and 2 with prob 0.35, to separate dataset into 2/3 ratio
ind <- sample(2, nrow(MyData), replace=TRUE, prob=c(0.65, 0.35))
#create 2 datasets from tables, without the last column (this is class label)
data.train<-MyData[ind==1,1:coln]
data.test<-MyData[ind==2,1:coln]
#set class labels for training and test sets
testlabels<-MyData[ind==2,coln]
trainlabels<-MyData[ind==1,coln]

#predict with svm
fitk <- ksvm(as.factor(Survived)~., data=data.train)
predictions <- predict(fitk, data.test)
CrossTable(data.test$Survived, predictions, type="C-Classification")

fitk <- ksvm(as.factor(Survived)~., data=MyData)
predictions <- predict(fitk, TestData)
write.csv(predictions, file = "svm.csv", col.names = TRUE)

#fit random forest
fitB <- randomForest(as.factor(Survived)~., data=data.train)
predictions <- predict(fitB, data.test)
CrossTable(data.test$Survived, predictions, type="C-Classification")

fitB <- randomForest(as.factor(Survived)~., data=MyData)
predictions <- predict(fitB, TestData)
write.csv(predictions, file = "forest.csv", col.names = TRUE)

#fit decision tree
fit <- J48(as.factor(Survived)~., data=data.train)
predictions <- predict(fit, data.test)
CrossTable(data.test$Survived, predictions, type="C-Classification")

fit <- J48(as.factor(Survived)~., data=MyData)
predictions <- predict(fit, TestData)
write.csv(predictions, file = "resultsj48.csv", col.names = TRUE)

#model_pred <- knn(train = data.train[,-c(1)], test = data.test[,-c(1)], cl = data.train[,1], k=1)
#CrossTable(x = data.test[,1], y = model_pred, prop.chisq=FALSE)

