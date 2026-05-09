/*
===============================================================================
07 - Cumulative Analysis
===============================================================================
Purpose:
    Calculate running totals over time.
===============================================================================
*/

USE DataWarehouseAnalytics;
GO

-- Calculate total sales per month.
SELECT
    DATETRUNC(MONTH, order_date) AS order_month,
    SUM(sales_amount) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH, order_date)
ORDER BY order_month;

-- Calculate running total sales over time.
WITH monthly_sales AS
(
    SELECT
        DATETRUNC(MONTH, order_date) AS order_month,
        SUM(sales_amount) AS total_sales
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(MONTH, order_date)
)
SELECT
    order_month,
    total_sales,
    SUM(total_sales) OVER(ORDER BY order_month) AS running_total_sales
FROM monthly_sales
ORDER BY order_month;

-- Calculate running total sales that resets every year.
WITH monthly_sales AS
(
    SELECT
        DATETRUNC(MONTH, order_date) AS order_month,
        SUM(sales_amount) AS total_sales
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(MONTH, order_date)
)
SELECT
    order_month,
    total_sales,
    SUM(total_sales) OVER(
        PARTITION BY YEAR(order_month)
        ORDER BY order_month
    ) AS running_total_sales_by_year
FROM monthly_sales
ORDER BY order_month;

-- Calculate running total sales by day that resets every month.
WITH daily_sales AS
(
    SELECT
        CAST(order_date AS DATE) AS order_day,
        SUM(sales_amount) AS total_sales
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY CAST(order_date AS DATE)
)
SELECT
    order_day,
    total_sales,
    SUM(total_sales) OVER(
        PARTITION BY DATETRUNC(MONTH, order_day)
        ORDER BY order_day
    ) AS running_total_sales_by_month
FROM daily_sales
ORDER BY order_day;

-- Running total with a clean display label.
WITH monthly_sales AS
(
    SELECT
        DATETRUNC(MONTH, order_date) AS order_month,
        SUM(sales_amount) AS total_sales
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(MONTH, order_date)
)
SELECT
    FORMAT(order_month, 'yyyy-MMM') AS order_month_label,
    total_sales,
    SUM(total_sales) OVER(ORDER BY order_month) AS running_total_sales
FROM monthly_sales
ORDER BY order_month;
