/*
===============================================================================
02 - Measure Exploration
===============================================================================
Purpose:
    Calculate high-level business measures such as sales, quantity, orders,
    products, and customers.
===============================================================================
*/

USE DataWarehouseAnalytics;
GO

-- Find the total sales amount.
SELECT
    SUM(sales_amount) AS total_sales
FROM gold.fact_sales;

-- Find the total quantity sold.
SELECT
    SUM(quantity) AS total_quantity
FROM gold.fact_sales;

-- Find the total number of order rows.
SELECT
    COUNT(order_number) AS total_order_rows
FROM gold.fact_sales;

-- Find the total number of unique orders.
SELECT
    COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales;

-- Find the total number of products.
SELECT
    COUNT(product_key) AS total_products
FROM gold.dim_products;

-- Find the total number of customers.
SELECT
    COUNT(customer_key) AS total_customers
FROM gold.dim_customers;

-- Find the total number of customers who placed an order.
SELECT
    COUNT(DISTINCT customer_key) AS total_customers_with_orders
FROM gold.fact_sales;

-- Build a simple KPI summary report.
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Customers With Orders', COUNT(DISTINCT customer_key) FROM gold.fact_sales;
