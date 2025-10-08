# NBA Shot Outcome Prediction

This project analyzes NBA player shooting data and builds machine learning models to predict whether a shot is made or missed based on various player, defender, and range attributes. The analysis explores data understanding, feature encoding, model training, and performance comparison across multiple algorithms.

## Project Overview

The goal of this project is to:

- Understand patterns and trends in NBA players’ shooting performance

- Build predictive models to classify shot outcomes

- Evaluate model accuracy and identify the most influential factors

## Key Steps

1. Data Understanding and Exploration

    - Performed exploratory data analysis (EDA) using dplyr, ggplot2, and skimr

    - Summarized key statistics and visualized distributions and relationships

2. Data Preparation

    - Removed unnecessary columns and handled missing values

    - Applied one-hot encoding using fastDummies for categorical features (Shooter, Defender, Range)

3. Model Development

    - Trained multiple models using the caret package:

        - Support Vector Machine (SVM)

        - Random Forest (RF)

        - Neural Network (NN)

    - Used 10-fold cross-validation for model evaluation

4. Performance Evaluation

    - Assessed models using confusion matrices and accuracy scores

    - Compared model performance and feature importance

## Tech Stack

Language: R

Libraries: caret, dplyr, ggplot2, fastDummies, skimr

RStudio

## Results Summary

Developed and compared SVM, Random Forest, and Neural Network models

Evaluated each model using 10-fold cross-validation

1. SVM (Polynomial Kernel)

    - Training Accuracy: 69.1%

    - Testing Accuracy: 67.7%
  
    - Sensitivity (MADE): 72.2% (training), 65.3% (testing)

    - Specificity (MISSED): 66.4% (training), 69.9% (testing)

    - Balanced Accuracy: 69.3% (training), 67.6% (testing)

2. Random Forest

    - Training Accuracy: 73.9%

    - Testing Accuracy: 63.9%

    - Sensitivity (MADE): 60.8% (training), 45.8% (testing)

    - Specificity (MISSED): 85.3% (training), 79.5% (testing)

    - Balanced Accuracy: 73.0% (training), 62.7% (testing)

3. Neural Network

    - Training Accuracy: 67.8%

    - Testing Accuracy: 65.2%

    - Sensitivity (MADE): 61.5% (training), 52.8% (testing)

    - Specificity (MISSED): 73.3% (training), 75.9% (testing)

    - Balanced Accuracy: 67.4% (training), 64.3% (testing)


Identified key factors influencing shot success:

Random Forest Model Feature Importance
<img width="1344" height="960" alt="image" src="https://github.com/user-attachments/assets/e64c1dde-1e31-4f5b-ab54-09febb91e1ad" />

Neural Network Model Feature IMportance
<img width="1344" height="960" alt="image" src="https://github.com/user-attachments/assets/2d6ba70f-1efe-487c-b39b-f0e6d612e42d" />

## How to Run

1. Clone this repository:

    git clone https://github.com/JaysonGiri/R-Programming-2021-NBA-Playoffs-Dataset.git


2. Open the project folder in RStudio.

3. Open and knit the R Markdown file to generate the HTML report.


## Author

Sanjay Giri Prakash

  Data Science | Machine Learning | Sports Analytics
