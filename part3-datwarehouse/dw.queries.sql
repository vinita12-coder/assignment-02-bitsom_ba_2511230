-- ============================================
-- PART 3: DATA WAREHOUSE - ANALYTICAL QUERIES
-- ============================================

USE retail_dw;

-- ============================================
-- Q1: Total sales revenue by product category for each month
-- ============================================
SELECT 
    dd.year,
    dd.month_name,
    dp.category,
    SUM(fs.sales_amount) AS total_revenue,
    SUM(fs.units_sold) AS total_units_sold
FROM fact_sales fs
JOIN dim_date dd ON fs.date_id = dd.date_id
JOIN dim_product dp ON fs.product_id = dp.product_id
GROUP BY dd.year, dd.month, dd.month_name, dp.category
ORDER BY dd.year, dd.month, dp.category;

-- ============================================
-- Q2: Top 2 performing stores by total revenue
-- ============================================
SELECT 
    ds.store_id,
    ds.store_name,
    ds.store_city,
    SUM(fs.sales_amount) AS total_revenue,
    COUNT(fs.sales_id) AS number_of_transactions,
    AVG(fs.sales_amount) AS average_transaction_value
FROM fact_sales fs
JOIN dim_store ds ON fs.store_id = ds.store_id
GROUP BY ds.store_id, ds.store_name, ds.store_city
ORDER BY total_revenue DESC
LIMIT 2;

-- ============================================
-- Q3: Month-over-month sales trend across all stores
-- ============================================
SELECT 
    dd.year,
    dd.month_name,
    SUM(fs.sales_amount) AS monthly_revenue,
    COUNT(fs.sales_id) AS transaction_count,
    AVG(fs.sales_amount) AS avg_transaction_value
FROM fact_sales fs
JOIN dim_date dd ON fs.date_id = dd.date_id
GROUP BY dd.year, dd.month, dd.month_name
ORDER BY dd.year, dd.month;
