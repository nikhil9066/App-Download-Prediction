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

