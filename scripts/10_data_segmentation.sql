/*
===============================================================================
10 - Data Segmentation
===============================================================================
Purpose:
    Group products and customers into meaningful business segments.
===============================================================================
*/

USE DataWarehouseAnalytics;
GO

-- Segment products into cost ranges and count how many products fall into each range.
WITH product_segments AS
(
    SELECT
        product_key,
        product_name,
        cost,
        CASE
            WHEN cost < 100 THEN 'Below 100'
            WHEN cost BETWEEN 100 AND 500 THEN '100-500'
            WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
            ELSE 'Above 1000'
        END AS cost_range
    FROM gold.dim_products
)
SELECT
    cost_range,
    COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC;

-- Segment customers based on spending behavior and lifespan.
WITH customer_spending AS
(
    SELECT
        c.customer_key,
        SUM(s.sales_amount) AS total_spending,
        MIN(s.order_date) AS first_order_date,
        MAX(s.order_date) AS last_order_date,
        DATEDIFF(MONTH, MIN(s.order_date), MAX(s.order_date)) AS lifespan_months
    FROM gold.fact_sales AS s
    LEFT JOIN gold.dim_customers AS c
        ON s.customer_key = c.customer_key
    WHERE s.order_date IS NOT NULL
    GROUP BY c.customer_key
),
customer_segments AS
(
    SELECT
        customer_key,
        CASE
            WHEN lifespan_months >= 12 AND total_spending > 5000 THEN 'VIP'
            WHEN lifespan_months >= 12 AND total_spending <= 5000 THEN 'Regular'
            ELSE 'New'
        END AS customer_segment
    FROM customer_spending
)
SELECT
    customer_segment,
    COUNT(customer_key) AS total_customers
FROM customer_segments
GROUP BY customer_segment
ORDER BY total_customers DESC;
