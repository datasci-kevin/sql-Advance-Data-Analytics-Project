/*
===============================================================================
03 - Dimension Exploration
===============================================================================
Purpose:
    Explore categorical attributes from dimension tables.
===============================================================================
*/

USE DataWarehouseAnalytics;
GO

-- Explore customer countries.
SELECT DISTINCT
    country
FROM gold.dim_customers
ORDER BY country;

-- Explore customer genders.
SELECT DISTINCT
    gender
FROM gold.dim_customers
ORDER BY gender;

-- Explore product categories and subcategories.
SELECT DISTINCT
    category,
    subcategory
FROM gold.dim_products
ORDER BY category, subcategory;
