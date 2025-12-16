SQL Sales Analysis Queries

This repository contains SQL queries for analyzing sales performance across multiple stores. The queries aggregate revenue data by day and week, track week-over-week growth, and evaluate online sales contributions.

Key Features:

1. Daily & Weekly Revenue: Summarizes total revenue per store per day and per week.
2. Revenue Growth: Calculates week-over-week revenue changes using window functions.
3. Online Sales Trends: Measures online sales share and its weekly shift.
4. Trend Indicators: Flags revenue and online sales trends as UP, DOWN, or No Change.

These queries demonstrate practical use of aggregation, date functions, window functions, and conditional logic to provide actionable business insights.

## Using the Dataset

The repository includes a CSV file with raw bookstore sales data.  

**IMPORTANT:** 
To run the SQL queries as-is, import the CSV into your database and name the table: "dbo.Sales"
This ensures all queries referencing "dbo.Sales" will work correctly.

Note: The bookstore_sales CSV is large and may not be previewed on GitHub. 
Download the file to use it with the SQL queries.
