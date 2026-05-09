# Exploratory Data Analysis Using SQL

This project contains SQL scripts for exploring a data warehouse using SQL Server. The analysis is organized into small, numbered files so each part can be uploaded to GitHub separately and reviewed step by step.

## Project Structure

| File | Topic |
|---|---|
| `00_database_context.sql` | Selects the working database |
| `01_date_range_exploration.sql` | Explores order dates and customer age range |
| `02_measure_exploration.sql` | Calculates key business measures |
| `03_dimension_exploration.sql` | Explores customer and product dimensions |
| `04_magnitude_analysis.sql` | Aggregates measures by dimensions |
| `05_ranking_analysis.sql` | Finds top and bottom performers |
| `06_change_over_time_analysis.sql` | Analyzes trends over time |
| `07_cumulative_analysis.sql` | Calculates running totals |
| `08_performance_analysis.sql` | Compares sales to averages and previous-year values |
| `09_part_to_whole_analysis.sql` | Calculates category contribution to total sales |
| `10_data_segmentation.sql` | Segments products and customers |
| `11_customer_report_view.sql` | Creates a customer-level report view |
| `12_product_report_view.sql` | Creates a product-level report view |

## Skills Demonstrated

- SQL aggregation with `SUM`, `COUNT`, `AVG`, `MIN`, and `MAX`
- Filtering and grouping data
- Joining fact and dimension tables
- Ranking with `ROW_NUMBER`
- Time-series analysis with `YEAR` and `DATETRUNC`
- Running totals with window functions
- Customer and product segmentation using `CASE`
- Report-building with SQL views

## Database Used

The scripts assume a SQL Server database named:

```sql
DataWarehouseAnalytics
```

The main tables used are:

```sql
gold.fact_sales
gold.dim_customers
gold.dim_products
```

## Notes

Some scripts use `DATETRUNC`, which is available in SQL Server 2022 and newer. If you are using an older SQL Server version, replace `DATETRUNC(MONTH, order_date)` with a compatible date expression.
