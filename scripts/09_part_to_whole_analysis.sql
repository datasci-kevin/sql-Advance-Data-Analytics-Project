/*
===============================================================================
09 - Part-to-Whole Analysis
===============================================================================
Purpose:
    Analyze how each category contributes to the overall sales total.
===============================================================================
*/

USE DataWarehouseAnalytics;
GO

-- Which product categories contribute the most to total sales?
WITH category_sales AS
(
    SELECT
        p.category,
        SUM(s.sales_amount) AS total_sales
    FROM gold.fact_sales AS s
    LEFT JOIN gold.dim_products AS p
        ON s.product_key = p.product_key
    GROUP BY p.category
)
SELECT
    category,
    total_sales,
    SUM(total_sales) OVER() AS overall_sales,
    CONCAT(
        ROUND((CAST(total_sales AS FLOAT) / NULLIF(SUM(total_sales) OVER(), 0)) * 100, 2),
        '%'
    ) AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC;
