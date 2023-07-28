# Nashville Housing Market Project

Nashville Housing Market: Data Cleaning using SQL

-   Link to SQL Data Cleaning Queries: [Nashville Housing Data Cleaning Queries](https://github.com/chelsiety/Nashville-Housing-Market-Project/blob/main/Nashville-Housing-Data-Cleaning-Queries.sql)

# Project Description

"Nashville Housing Market Data Cleaning" is a guided project sourced from YouTube, utilizing a dataset acquired from Kaggle. The project focuses on preparing the Nashville Housing Market Dataset for analysis by addressing inconsistencies, missing information, and duplicates. I utilized SQL concepts such as Common Table Expressions (CTEs), Window functions, along with various SQL functions to clean and transform the data. The project resulted in a more accurate and consistent dataset, enabling in-depth exploration of Nashville's housing market trends.

# Project Summary

Nashville Housing Market Data Cleaning with SQL

## Problem Statement

The Nashville Housing Market Dataset from Kaggle presented substantial challenges in terms of data accuracy and consistency, which hindered its potential for valuable analysis. The main objective of this project was to perform an extensive data cleaning process using SQL to address data quality issues and to prepare the dataset for further exploration and analysis.

## Key Findings

Through the application of SQL functions and techniques, the data cleaning process successfully addressed several issues within the dataset:

1.  **Standardized Date Format**: The date-time format was converted and standardized to the date format across all records, ensuring uniformity and facilitating streamlined analysis. SQL functions such as ALTER TABLE, DATE, and CONVERT were used for this transformation.

2.  **Missing Property Address Data**: By populating empty fields, the dataset's reliability was enhanced, reducing potential errors in location-based queries. Some SQL functions used were INNER JOIN and WHERE functions.

3.  **Organized Data Structure**: Property addresses were efficiently split into 2 individual columns (street address, city). SQL functions like SUBSTRING, TRIM, UPDATE, and SET were used for this data transformation. Owner addresses were split into 3 columns (street address, city, state) using PARSENAME and REPLACE SQL functions. Splitting the addresses into individual columns significantly improved data organization for better query performance and enhanced location-based insights.

4.  **Standardized Categorical Data**: Categorical data represented as "Y" and "N" were transformed to "Yes" and "No," respectively. This transformation improved the interpretability of the dataset. SQL functions like GROUP BY, ORDER BY, and CASE were applied.

5.  **Duplicate Removal**: Utilizing SQL concepts such as Common Table Expressions (CTEs) and Window functions (e.g., ROW_NUMBER), duplicates were effectively removed.

## Recommendations

To maximize the dataset's potential, it is recommended to continue the analysis with the following steps:

1.  **Exploratory Data Analysis**: Conduct in-depth exploratory data analysis to uncover patterns, trends, and potential insights into the Nashville housing market.

2.  **Predictive Modeling**: Utilize advanced statistical and machine learning techniques to build predictive models that can forecast housing market trends and identify factors influencing property prices.

3.  **Data Visualization**: Create visually appealing and informative data visualizations to effectively communicate findings and recommendations to stakeholders.
