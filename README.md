# App-Download-Prediction
This project predicts whether a smartphone user will download an app after clicking a mobile ad using Random Forest. It includes data preprocessing, feature engineering, model building, and evaluation. Key insights include feature importance and model accuracy, with visualizations to support analysis.

## Table of Contents
- [Data Overview](#data-overview)
- [Installation](#installation)
- [Usage](#usage)
- [Running the Code](#running-the-code)
- [Features](#features)
- [Requirements](#requirements)
- [Conclusion](#conclusion)

## Data Overview

The dataset `data.csv` includes user click data with the following variables:

- **V1**: IP address of the click.
- **V2**: App ID for marketing.
- **V3**: Device type ID of the user's mobile phone (e.g., iPhone 6 Plus, iPhone 7, Huawei Mate 7).
- **V4**: OS version ID of the user's mobile phone.
- **V5**: Channel ID of the mobile ad publisher.
- **V6**: Timestamp of the click (UTC).
- **V7**: Time of app download if the user downloads the app after clicking an ad.
- **V8**: Target variable indicating if the app was downloaded (1 for download, 0 for no download).

The task involves splitting the dataset into a 50:50 ratio for training and testing, setting a seed for reproducibility, and building a random forest classifier to predict the target variable V8.

## Installation

Ensure that R and RStudio are installed. Clone the repository to your local machine and set up the required R packages:

```bash
git clone https://github.com/yourusername/app_download_prediction.git
cd app_download_prediction
```

## Usage

1. Place the `data.csv` file in the working directory.
2. Open the `app_download_prediction.Rmd` file in RStudio.
3. Run the RMarkdown file to execute the code, generate outputs, and compile the analysis into a PDF or Word document.

The RMarkdown file includes all the necessary code chunks, model results, visualizations, and commentary. The results will also display key performance metrics like accuracy, confusion matrix, and tuning parameters.

## Running the Code

To run the project, follow these steps:

1. Open `app_download_prediction.Rmd` in RStudio.
2. Run the code chunks by clicking the "Knit" button to generate the report.
3. The output will contain the random forest model results, including cross-validation accuracy, confusion matrix, and model performance.

## Features

1. **Data Preprocessing:**
   - Reading the dataset from a CSV file.
   - Assigning column names and inspecting data structure.
   - Splitting data into training and test sets (50:50 split).
   - Setting a seed to ensure reproducibility.

2. **Random Forest Model:**
   - Training a random forest model with V8 (app download) as the target variable.
   - Using cross-validation to optimize the model’s performance.
   - Tuning the `mtry` parameter (number of variables tried at each split).
   - Reporting key metrics like accuracy and Kappa.

3. **Model Evaluation:**
   - Confusion matrix showing predicted vs actual classifications.
   - Calculation of accuracy, sensitivity, specificity, and balanced accuracy.
   - McNemar’s test and additional statistical measures for model performance.

4. **Hyperparameter Tuning:**
   - Cross-validated random forest model with `mtry` values ranging from 2 to 5.
   - Selecting the optimal model based on accuracy.

## Requirements

To run the code, you need to install the following R packages:

- `randomForest`
- `caret`
- `readr`
- `dplyr`
- `ggplot2`
- `knitr`
- `rmarkdown`

Install them in RStudio using:

```r
install.packages(c("randomForest", "caret", "readr", "dplyr", "ggplot2", "knitr", "rmarkdown"))
```

## Conclusion

This project demonstrates how to build a random forest model to predict app downloads based on clickstream data. The model performed with high accuracy, though it revealed challenges with class imbalance, as seen in the specificity and McNemar's test results. The final model can be used for further analysis to optimize mobile ad targeting strategies and improve user acquisition metrics in mobile marketing campaigns.

Feel free to fork the project, raise issues, or contribute by submitting pull requests. All contributions are welcome!