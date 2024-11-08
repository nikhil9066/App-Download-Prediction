# Load necessary libraries
library(tidyverse)
library(randomForest)
library(ggplot2)
library(pROC)
library(caret)

set.seed(555)

# Load the dataset
data <- read.csv("data.csv", sep=",", header=FALSE)
colnames(data) <- c("V1", "V2", "V3", "V4", "V5", "V6", "V7", "V8")

# Convert target variable V8 to a factor (binary classification)
data$V8 <- as.factor(data$V8)

# Split the data into 50% training and 50% testing
trainIndex <- createDataPartition(data$V8, p = 0.5, list = FALSE)
trainData <- data[trainIndex, ]
testData <- data[-trainIndex, ]

# Pre-forest: Visualize distribution of target variable
ggplot(data, aes(x = V8)) + 
  geom_bar(fill = "steelblue") +
  labs(title = "Distribution of App Download (V8)", x = "App Download (0 or 1)", y = "Count")

# Pre-forest: Visualize distribution of a feature (V2)
ggplot(data, aes(x = V2, fill = V8)) + 
  geom_histogram(binwidth = 1, color = "black", position = "dodge") +
  labs(title = "Distribution of V2 (App ID) by Download Status", x = "App ID (V2)", y = "Count")

# Build the initial random forest model
rf_model <- randomForest(V8 ~ V1 + V2 + V3 + V4 + V5, data = trainData)
print(rf_model)

# Post-forest: Feature importance
varImpPlot(rf_model, main = "Variable Importance")

# Predictions on test set and confusion matrix
predictions <- predict(rf_model, testData)
conf_matrix <- confusionMatrix(predictions, testData$V8)
print(conf_matrix)

# Post-forest: ROC curve and AUC
roc_curve <- roc(testData$V8, as.numeric(predictions))
plot(roc_curve, col = "blue", main = "ROC Curve for Random Forest Model")
auc_value <- auc(roc_curve)
cat("AUC:", auc_value, "\n")

# Feature Engineering: Creating interaction terms
data$V2_V3_interaction <- data$V2 * data$V3
data$V4_V5_interaction <- data$V4 * data$V5

# Convert V6 and V7 (timestamps) to numeric
data$V6 <- as.numeric(as.POSIXct(data$V6, format = "%m/%d/%y %H:%M", tz = "UTC"))
data$V7[data$V7 == ""] <- NA
data$V7 <- as.numeric(as.POSIXct(data$V7, format = "%m/%d/%y %H:%M", tz = "UTC"))

# Split data after feature engineering
trainData <- data[trainIndex, ]
testData <- data[-trainIndex, ]

# Hyperparameter tuning using caret
tuneGrid <- expand.grid(mtry = 2:5)
control <- trainControl(method = "cv", number = 5)

# Train the model with tuning
rf_tuned <- train(V8 ~ V1 + V2 + V3 + V4 + V5 + V2_V3_interaction + V4_V5_interaction, 
                  data = trainData, 
                  method = "rf", 
                  tuneGrid = tuneGrid, 
                  trControl = control)

# Print tuned model results
print(rf_tuned)

# Feature importance after tuning
varImpPlot(rf_tuned$finalModel, main = "Variable Importance after Tuning")

# Predictions on test data with the tuned model
predictions <- predict(rf_tuned, newdata = testData)

# Confusion matrix and performance metrics
conf_matrix <- confusionMatrix(predictions, testData$V8)
print(conf_matrix)

# ROC curve and AUC after tuning
roc_curve <- roc(testData$V8, as.numeric(predictions))
plot(roc_curve, col = "blue", main = "ROC Curve after Tuning")
auc_value <- auc(roc_curve)
cat("AUC after tuning:", auc_value, "\n")

# Apply SMOTE for class imbalance handling
library(DMwR)
trainData_balanced <- SMOTE(V8 ~ V1 + V2 + V3 + V4 + V5, data = trainData, perc.over = 100, perc.under = 200)

# Add interaction terms to the balanced data
trainData_balanced$V2_V3_interaction <- trainData_balanced$V2 * trainData_balanced$V3
trainData_balanced$V4_V5_interaction <- trainData_balanced$V4 * trainData_balanced$V5

# Retrain the model with SMOTE applied
rf_tuned_balanced <- train(V8 ~ V1 + V2 + V3 + V4 + V5 + V2_V3_interaction + V4_V5_interaction, 
                           data = trainData_balanced, 
                           method = "rf", 
                           tuneGrid = tuneGrid, 
                           trControl = control)

# Predictions on test data with the balanced model
predictions_balanced <- predict(rf_tuned_balanced, newdata = testData)

# Confusion matrix for balanced model
conf_matrix_balanced <- confusionMatrix(predictions_balanced, testData$V8)
print(conf_matrix_balanced)

# ROC curve and AUC for balanced model
roc_curve_balanced <- roc(testData$V8, as.numeric(predictions_balanced))
plot(roc_curve_balanced, col = "blue", main = "ROC Curve after SMOTE and Tuning")
auc_value_balanced <- auc(roc_curve_balanced)
cat("AUC after SMOTE and tuning:", auc_value_balanced, "\n")
