library(tidyverse)
library(randomForest)
library(ggplot2)
library(pROC)
library(caret)

set.seed(555)

data <- read.csv("data.csv", sep=",", header=FALSE)

colnames(data) <- c("V1", "V2", "V3", "V4", "V5", "V6", "V7", "V8")

head(data)

summary(data)

colSums(is.na(data))

# Convert target variable V8 to factor (binary classification)
data$V8 <- as.factor(data$V8)

# Check correlations (ignoring categorical variables)
correlations <- cor(data[c("V2", "V3", "V4", "V5", "V2_V3_interaction", "V4_V5_interaction")])
print(correlations)

# Split the data into 50% training and 50% testing
trainIndex <- createDataPartition(data$V8, p = 0.5, list = FALSE)
trainData <- data[trainIndex, ]
testData <- data[-trainIndex, ]

# Pre-forest: Visualize distribution of target variable
ggplot(data, aes(x = V8)) + 
  geom_bar(fill = "steelblue") +
  labs(title = "Distribution of App Download (V8)", x = "App Download (0 or 1)", y = "Count")

# Pre-forest: Visualize distribution of a feature (e.g., V2)
ggplot(data, aes(x = V2, fill = V8)) + 
  geom_histogram(binwidth = 1, color = "black", position = "dodge") +
  labs(title = "Distribution of V2 (App ID) by Download Status", x = "App ID (V2)", y = "Count")

# Build the random forest model
rf_model <- randomForest(V8 ~ V1 + V2 + V3 + V4 + V5, data = trainData)

# Print model summary
print(rf_model)

# Post-forest: Plot feature importance
importance <- importance(rf_model)
varImpPlot(rf_model, main = "Variable Importance")

# Make predictions on the test set
predictions <- predict(rf_model, testData)

# Post-forest: Confusion matrix
conf_matrix <- confusionMatrix(predictions, testData$V8)
print(conf_matrix)

# Post-forest: ROC curve
roc_curve <- roc(testData$V8, as.numeric(predictions))
plot(roc_curve, col = "blue", main = "ROC Curve for Random Forest Model")
auc_value <- auc(roc_curve)
cat("AUC:", auc_value, "\n")

print("------------------------------------------------------------------------------")

# Feature Engineering: Creating interaction terms
data$V2_V3_interaction <- data$V2 * data$V3
data$V4_V5_interaction <- data$V4 * data$V5

# Hyperparameter tuning using caret
tuneGrid <- expand.grid(mtry = 2:5)  # Testing mtry from 2 to 5
control <- trainControl(method = "cv", number = 5)  # 5-fold cross-validation

# Train the model with tuning
rf_tuned <- train(V8 ~ V1 + V2 + V3 + V4 + V5 + V2_V3_interaction + V4_V5_interaction, 
                  data = trainData, 
                  method = "rf", 
                  tuneGrid = tuneGrid, 
                  trControl = control)
print(rf_tuned)

# Get the best model and its parameters
best_mtry <- rf_tuned$bestTune$mtry
print(paste("Best mtry:", best_mtry))

library(DMwR)

# Apply SMOTE for balancing
trainData_balanced <- SMOTE(V8 ~ V1 + V2 + V3 + V4 + V5, data = trainData, perc.over = 100, perc.under = 200)

# Check the distribution after SMOTE
table(trainData_balanced$V8)
