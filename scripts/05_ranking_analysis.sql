/*
===============================================================================
05 - Ranking Analysis
===============================================================================
Purpose:
    Identify top and bottom performers using ORDER BY, TOP, and window functions.
===============================================================================
*/

USE DataWarehouseAnalytics;
GO

-- Find the top 5 products that generated the highest revenue.
SELECT TOP 5
    p.product_name,
    SUM(s.sales_amount) AS total_sales
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
    ON s.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_sales DESC;

-- Find the bottom 5 products by revenue.
SELECT TOP 5
    p.product_name,
    SUM(s.sales_amount) AS total_sales
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
    ON s.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_sales ASC;

-- Find the top 5 products using a window function.
SELECT
    product_name,
    total_sales,
    product_rank
FROM
(
    SELECT
        p.product_name,
        SUM(s.sales_amount) AS total_sales,
        ROW_NUMBER() OVER(ORDER BY SUM(s.sales_amount) DESC) AS product_rank
    FROM gold.fact_sales AS s
    LEFT JOIN gold.dim_products AS p
        ON s.product_key = p.product_key
    GROUP BY p.product_name
) AS ranked_products
WHERE product_rank <= 5;

-- Find the top 10 customers who generated the highest revenue.
SELECT
    customer_key,
    first_name,
    last_name,
    total_sales,
    customer_rank
FROM
(
    SELECT
        c.customer_key,
        c.first_name,
        c.last_name,
        SUM(s.sales_amount) AS total_sales,
        ROW_NUMBER() OVER(ORDER BY SUM(s.sales_amount) DESC) AS customer_rank
    FROM gold.fact_sales AS s
    LEFT JOIN gold.dim_customers AS c
        ON s.customer_key = c.customer_key
    GROUP BY
        c.customer_key,
        c.first_name,
        c.last_name
) AS ranked_customers
WHERE customer_rank <= 10;

-- Find the 3 customers with the lowest number of orders.
SELECT
    customer_key,
    first_name,
    last_name,
    total_orders,
    customer_rank
FROM
(
    SELECT
        c.customer_key,
        c.first_name,
        c.last_name,
        COUNT(DISTINCT s.order_number) AS total_orders,
        ROW_NUMBER() OVER(ORDER BY COUNT(DISTINCT s.order_number) ASC) AS customer_rank
    FROM gold.fact_sales AS s
    LEFT JOIN gold.dim_customers AS c
        ON s.customer_key = c.customer_key
    GROUP BY
        c.customer_key,
        c.first_name,
        c.last_name
) AS ranked_customers
WHERE customer_rank <= 3;
