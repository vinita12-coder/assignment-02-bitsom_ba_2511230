-- ============================================
-- PART 3: DATA WAREHOUSE - STAR SCHEMA DESIGN
-- ============================================

-- Create a new database for the data warehouse
DROP DATABASE IF EXISTS retail_dw;
CREATE DATABASE retail_dw;
USE retail_dw;

-- ============================================
-- DIMENSION TABLE 1: dim_date
-- ============================================
CREATE TABLE dim_date (
    date_id INT PRIMARY KEY AUTO_INCREMENT,
    date DATE NOT NULL UNIQUE,
    day_of_week VARCHAR(10),
    month INT,
    month_name VARCHAR(15),
    quarter INT,
    year INT
);

-- ============================================
-- DIMENSION TABLE 2: dim_store
-- ============================================
CREATE TABLE dim_store (
    store_id INT PRIMARY KEY AUTO_INCREMENT,
    store_name VARCHAR(100) NOT NULL,
    store_city VARCHAR(50) NOT NULL UNIQUE
);

-- ============================================
-- DIMENSION TABLE 3: dim_product
-- ============================================
CREATE TABLE dim_product (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL
);

-- ============================================
-- FACT TABLE: fact_sales
-- ============================================
CREATE TABLE fact_sales (
    sales_id INT PRIMARY KEY AUTO_INCREMENT,
    date_id INT NOT NULL,
    store_id INT NOT NULL,
    product_id INT NOT NULL,
    units_sold INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    sales_amount DECIMAL(15, 2) NOT NULL,
    FOREIGN KEY (date_id) REFERENCES dim_date(date_id),
    FOREIGN KEY (store_id) REFERENCES dim_store(store_id),
    FOREIGN KEY (product_id) REFERENCES dim_product(product_id)
);

-- ============================================
-- POPULATE DIMENSION TABLES
-- ============================================

-- Insert Dates (Sample dates from the data)
INSERT INTO dim_date (date, day_of_week, month, month_name, quarter, year) VALUES
('2023-01-15', 'Sunday', 1, 'January', 1, 2023),
('2023-01-24', 'Tuesday', 1, 'January', 1, 2023),
('2023-02-05', 'Sunday', 2, 'February', 1, 2023),
('2023-02-08', 'Wednesday', 2, 'February', 1, 2023),
('2023-03-31', 'Friday', 3, 'March', 1, 2023),
('2023-05-21', 'Sunday', 5, 'May', 2, 2023),
('2023-05-22', 'Monday', 5, 'May', 2, 2023),
('2023-06-04', 'Sunday', 6, 'June', 2, 2023),
('2023-08-01', 'Tuesday', 8, 'August', 3, 2023),
('2023-08-09', 'Wednesday', 8, 'August', 3, 2023),
('2023-10-03', 'Tuesday', 10, 'October', 4, 2023),
('2023-10-26', 'Thursday', 10, 'October', 4, 2023),
('2023-11-18', 'Saturday', 11, 'November', 4, 2023),
('2023-12-08', 'Thursday', 12, 'December', 4, 2023);

-- Insert Stores (Cleaned data - standardized naming)
INSERT INTO dim_store (store_name, store_city) VALUES
('Chennai Anna', 'Chennai'),
('Delhi South', 'Delhi'),
('Bangalore MG', 'Bangalore'),
('Pune FC Road', 'Pune'),
('Mumbai Central', 'Mumbai');

-- Insert Products (Cleaned data - standardized categories)
INSERT INTO dim_product (product_name, category) VALUES
('Speaker', 'Electronics'),
('Tablet', 'Electronics'),
('Phone', 'Electronics'),
('Smartwatch', 'Electronics'),
('Laptop', 'Electronics'),
('Headphones', 'Electronics'),
('Atta 10kg', 'Grocery'),
('Biscuits', 'Grocery'),
('Milk 1L', 'Grocery'),
('Pulses 1kg', 'Grocery'),
('Jeans', 'Clothing'),
('Jacket', 'Clothing'),
('Saree', 'Clothing');

-- ============================================
-- POPULATE FACT TABLE (Sample data - cleaned)
-- ============================================
INSERT INTO fact_sales (date_id, store_id, product_id, units_sold, unit_price, sales_amount) VALUES
-- Transaction 1
(1, 2, 2, 14, 23226.12, 325165.68),
-- Transaction 2
(2, 1, 12, 20, 48703.39, 974067.80),
-- Transaction 3
(3, 2, 10, 12, 52464.00, 629568.00),
-- Transaction 4
(4, 3, 6, 6, 58851.01, 353106.06),
-- Transaction 5
(5, 4, 4, 16, 2317.47, 37079.52),
-- Transaction 6
(6, 3, 5, 13, 42343.15, 550461.95),
-- Transaction 7
(7, 3, 9, 9, 27469.99, 247229.91),
-- Transaction 8
(8, 1, 6, 15, 39854.96, 597824.40),
-- Transaction 9
(9, 5, 13, 11, 35451.81, 389969.91),
-- Transaction 10
(10, 2, 7, 12, 52464.00, 629568.00),
-- Transaction 11
(11, 5, 6, 8, 39854.96, 318839.68),
-- Transaction 12
(12, 4, 8, 3, 2317.47, 6952.41),
-- Transaction 13
(13, 2, 1, 14, 23226.12, 325165.68),
-- Transaction 14
(14, 3, 11, 5, 30187.24, 150936.20);

-- ============================================
-- VERIFICATION QUERIES
-- ============================================
-- Check the schema was created correctly
SELECT COUNT(*) AS total_dates FROM dim_date;
SELECT COUNT(*) AS total_stores FROM dim_store;
SELECT COUNT(*) AS total_products FROM dim_product;
SELECT COUNT(*) AS total_sales_records FROM fact_sales;
