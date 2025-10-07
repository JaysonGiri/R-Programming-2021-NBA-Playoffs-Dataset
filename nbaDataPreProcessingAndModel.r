# Load NBA shooting dataset
nba <- nba_players_shooting

# Check to see if there are missing data?
sum(is.na(nba)) # Returns the number of missing values in the dataset


library(dplyr)

# Removing unnecessary column INDEX
nba_new <- nba %>% 
  select(-INDEX)

library(fastDummies)

# One-hot encoding for categorical columns
# Converts SHOOTER, DEFENDER, and RANGE into dummy variables (0/1)
# remove_first_dummy = FALSE keeps all levels (no reference dropped)
# remove_selected_columns = TRUE removes the original categorical columns
nba_ml <- fastDummies::dummy_cols(
  nba_new,
  select_columns = c("SHOOTER", "DEFENDER", "RANGE"),
  remove_first_dummy = FALSE, 
  remove_selected_columns = TRUE 
)

# To achieve reproducible model; set the random seed number
set.seed(100)

library(caret) 

# Stratified random split into training (80%) and testing (20%) sets
TrainingIndex <- createDataPartition(nba_ml$SCORE, p = 0.8, list = FALSE)
TrainingSet <- nba_ml[TrainingIndex, ] # Training Set
TestingSet <- nba_ml[-TrainingIndex, ] # Test Set

# Build Training model

# SVM (Polynomial Kernel)
Model <- train(SCORE ~ ., data = TrainingSet, # Predict SCORE using all other variables and Use the training dataset
               method = "svmPoly",          # SVM with polynomial kernel
               na.action = na.omit, # missing value perform omission
               preProcess = c("scale", "center"), # it will scale the data according to mean centering, for each variable it will compute the mean value and then it will subtract each value of each row it will subtract with the mean value of each column
               trControl = trainControl(method = "cv", number = 10),     # 10-fold cross-validation
               tuneLength = 5        # Try 5 values of tuning parameters automatically
)

# Ensure the target variable has correct factor levels
levels_order <- c("MADE", "MISSED")  
TrainingSet$SCORE <- factor(TrainingSet$SCORE, levels = levels_order)
TestingSet$SCORE  <- factor(TestingSet$SCORE,  levels = levels_order)


# Apply model for prediction
Model.training <- factor(predict(Model, TrainingSet), levels = levels_order) # Apply model to make prediction on Training set
Model.testing <- factor(predict(Model, TestingSet), levels = levels_order) # Apply model to make prediction on Testing set

# Model performance (Displays confusion matrix and statistics)
Model.training.confusion <- confusionMatrix(Model.training, TrainingSet$SCORE)
Model.testing.confusion <- confusionMatrix(Model.testing, TestingSet$SCORE)

print(Model.training.confusion)
print(Model.testing.confusion)

# Random Forest

Model_rf <- train(SCORE ~ ., data = TrainingSet, 
                  method = "rf",
                  trControl = trainControl(method = "cv", number = 10),
                  tuneLength = 5
)

# Predictions for training and testing
Model_rf.training <- predict(Model_rf, TrainingSet)
Model_rf.testing <- predict(Model_rf, TestingSet)

# Confusion matrices
Model_rf.training.confusion <- confusionMatrix(Model_rf.training, TrainingSet$SCORE)
Model_rf.testing.confusion <- confusionMatrix(Model_rf.testing, TestingSet$SCORE)

print(Model_rf.training.confusion)
print(Model_rf.testing.confusion)

# Feature importance plot
Importance <- varImp(Model_rf)
plot(Importance)

# XGBoost

Model_xgb <- train(SCORE ~ ., data = TrainingSet,
                   method = "xgbTree",
                   trControl = trainControl(method = "cv", number = 10),
                   tuneLength = 5
)

Model_xgb.training <- predict(Model_xgb, TrainingSet)
Model_xgb.testing <- predict(Model_xgb, TestingSet)

Model_xgb.training.confusion <- confusionMatrix(Model_xgb.training, TrainingSet$SCORE)
Model_xgb.testing.confusion <- confusionMatrix(Model_xgb.testing, TestingSet$SCORE)

print(Model_xgb.training.confusion)
print(Model_xgb.testing.confusion)

Importance <- varImp(Model_xgb)
plot(Importance)

# Neural Network

Model_nnet <- train(SCORE ~ ., data = TrainingSet,
                    method = "nnet",
                    preProcess = c("center", "scale"),
                    trControl = trainControl(method = "cv", number = 10),
                    tuneLength = 5
)

Model_nnet.training <- predict(Model_nnet, TrainingSet)
Model_nnet.testing <- predict(Model_nnet, TestingSet)

Model_nnet.training.confusion <- confusionMatrix(Model_nnet.training, TrainingSet$SCORE)
Model_nnet.testing.confusion <- confusionMatrix(Model_nnet.testing, TestingSet$SCORE)

print(Model_nnet.training.confusion)
print(Model_nnet.testing.confusion)

Importance <- varImp(Model_nnet)
plot(Importance)

