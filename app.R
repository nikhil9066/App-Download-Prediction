# Load necessary libraries
library(tidyverse)
library(randomForest)
library(ggplot2)

# Read the data using a comma separator
data <- read.csv("data.csv", sep=",", header=FALSE)

# Assign proper column names
colnames(data) <- c("V1", "V2", "V3", "V4", "V5", "V6", "V7", "V8")

# View the first few rows to ensure it's correct
head(data)

# Summary statistics of the dataset
summary(data)

# Check for missing values
colSums(is.na(data))

# Distribution of the target variable (V8)
table(data$V8)
ggplot(data, aes(x = factor(V8))) + 
  geom_bar(fill = "lightblue") + 
  labs(x = "Downloaded (V8)", y = "Count") +
  ggtitle("Distribution of App Download (Target Variable)")

# Convert timestamp to datetime format
data$V6 <- as.POSIXct(data$V6, format="%m/%d/%y %H:%M")

# Encode categorical variables (if needed, using V1 to V5 which are coded already)
data$V1 <- as.factor(data$V1)
data$V2 <- as.factor(data$V2)
data$V3 <- as.factor(data$V3)
data$V4 <- as.factor(data$V4)
data$V5 <- as.factor(data$V5)

# Split the dataset into training and testing (50:50 split)
set.seed(555)
train_idx <- sample(1:nrow(data), 0.5 * nrow(data))
train_data <- data[train_idx, ]
test_data <- data[-train_idx, ]

# Extract hour from the timestamp for additional feature
data$hour <- as.numeric(format(data$V6, "%H"))

# Visualize feature relationships
ggplot(data, aes(x = factor(hour), fill = factor(V8))) + 
  geom_bar(position = "fill") + 
  labs(x = "Hour of Click", y = "Proportion of Downloads") +
  ggtitle("App Download Proportion by Hour of Click")

# Train the Random Forest model
set.seed(555)