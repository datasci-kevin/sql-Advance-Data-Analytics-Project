/*
===============================================================================
01 - Date Range Exploration
===============================================================================
Purpose:
    Understand the available date range in the sales data and customer data.
===============================================================================
*/

USE DataWarehouseAnalytics;
GO

-- Find the first and last order date.
SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date
FROM gold.fact_sales;

-- Find how many years of sales are available.
SELECT
    DATEDIFF(YEAR, MIN(order_date), MAX(order_date)) AS order_range_years
FROM gold.fact_sales;

-- Find the oldest and youngest customer based on birthdate.
SELECT
    MIN(birthdate) AS oldest_birthdate,
    DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS oldest_age,
    MAX(birthdate) AS youngest_birthdate,
    DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS youngest_age
FROM gold.dim_customers;
