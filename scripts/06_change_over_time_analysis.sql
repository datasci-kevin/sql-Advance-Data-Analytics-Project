/*
===============================================================================
06 - Change Over Time Analysis
===============================================================================
Purpose:
    Analyze how sales, customers, and quantity change over time.
===============================================================================
*/

USE DataWarehouseAnalytics;
GO

-- Analyze sales performance by order date.
SELECT
    order_date,
    SUM(sales_amount) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY order_date
ORDER BY order_date;

-- Analyze sales performance by year.
SELECT
    YEAR(order_date) AS order_year,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY order_year;

-- Analyze sales performance by year using DATETRUNC.
SELECT
    DATETRUNC(YEAR, order_date) AS order_year,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(YEAR, order_date)
ORDER BY order_year;

-- Analyze sales performance by month.
-- FORMAT is only used for the display label. The real date column is kept for correct sorting.
WITH monthly_sales AS
(
    SELECT
        DATETRUNC(MONTH, order_date) AS order_month,
        COUNT(DISTINCT customer_key) AS total_customers,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(MONTH, order_date)
)
SELECT
    FORMAT(order_month, 'yyyy-MMM') AS order_month_label,
    total_customers,
    total_sales,
    total_quantity
FROM monthly_sales
ORDER BY order_month;
