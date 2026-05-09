/*
===============================================================================
08 - Performance Analysis
===============================================================================
Purpose:
    Compare current sales performance to average sales and previous-year sales.
===============================================================================
*/

USE DataWarehouseAnalytics;
GO

-- Analyze yearly product sales.
WITH yearly_product_sales AS
(
    SELECT
        YEAR(s.order_date) AS order_year,
        p.product_name,
        SUM(s.sales_amount) AS current_sales
    FROM gold.fact_sales AS s
    LEFT JOIN gold.dim_products AS p
        ON s.product_key = p.product_key
    WHERE s.order_date IS NOT NULL
    GROUP BY
        YEAR(s.order_date),
        p.product_name
),
product_performance AS
(
    SELECT
        order_year,
        product_name,
        current_sales,
        AVG(current_sales) OVER(PARTITION BY product_name) AS avg_sales,
        LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS previous_year_sales
    FROM yearly_product_sales
)
SELECT
    order_year,
    product_name,
    current_sales,
    avg_sales,
    current_sales - avg_sales AS diff_from_avg,
    CASE
        WHEN current_sales - avg_sales > 0 THEN 'Above Avg'
        WHEN current_sales - avg_sales < 0 THEN 'Below Avg'
        ELSE 'Avg'
    END AS avg_change,
    previous_year_sales,
    current_sales - previous_year_sales AS diff_from_previous_year,
    CASE
        WHEN previous_year_sales IS NULL THEN 'No Previous Year'
        WHEN current_sales - previous_year_sales > 0 THEN 'Increase'
        WHEN current_sales - previous_year_sales < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS previous_year_change
FROM product_performance
ORDER BY product_name, order_year;
