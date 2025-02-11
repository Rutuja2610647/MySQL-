# 1 .Create Database
CREATE DATABASE WalmartSalesData;
USE WalmartSalesData;

# 2. Create Sales Table
CREATE TABLE Sales (
    invoice_id VARCHAR(20) PRIMARY KEY,
    branch CHAR(1),
    city VARCHAR(50),
    customer_type VARCHAR(10),
    gender VARCHAR(10),
    product_line VARCHAR(50),
    unit_price DECIMAL(10,2),
    quantity INT,
    tax DECIMAL(10,2),
    total DECIMAL(10,2),
    date DATE,
    time TIME,
    payment_method VARCHAR(20),
    cogs DECIMAL(10,2),
    gross_margin_percentage DECIMAL(10,2),
    gross_income DECIMAL(10,2),
    rating DECIMAL(3,1)
);
SHOW TABLES;
SELECT * FROM sales

# 3. LOCAL INFILE 
SET GLOBAL local_infile = 1;

# 4. CSV Data import table from
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/WalmartSalesData.csv'
INTO TABLE Sales
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(invoice_id, branch, city, customer_type, gender, product_line, unit_price, quantity, tax, total, 
@date, time, payment_method, cogs, gross_margin_percentage, gross_income, rating)
SET date = STR_TO_DATE(@date, '%m/%d/%Y');

# 5. Data Verify
SELECT COUNT(*) FROM Sales;
SELECT * FROM Sales LIMIT 10;

# 6. Data Analysis Queries
-- 1. (Total Sales per Branch)

SELECT branch, SUM(total) AS total_sales 
FROM Sales 
GROUP BY branch 
ORDER BY total_sales DESC;

-- Most sold product lines
SELECT product_line, SUM(quantity) AS total_sold 
FROM Sales 
GROUP BY product_line 
ORDER BY total_sold DESC;

-- Sales trends over time
SELECT date, SUM(total) AS daily_sales 
FROM Sales 
GROUP BY date 
ORDER BY date;

-- Customer type spending analysis
SELECT customer_type, SUM(total) AS total_spent 
FROM Sales 
GROUP BY customer_type 
ORDER BY total_spent DESC;

-- Payment method popularity
SELECT payment_method, COUNT(*) AS payment_count 
FROM Sales 
GROUP BY payment_method 
ORDER BY payment_count DESC;

-- Impact of rating on sales
SELECT rating, AVG(total) AS avg_spent 
FROM Sales 
GROUP BY rating 
ORDER BY rating DESC;

-- Count unique cities
SELECT COUNT(DISTINCT city) AS unique_cities FROM sales;

-- List cities and their respective branches
SELECT DISTINCT city, branch FROM sales;

-- Count unique product lines
SELECT COUNT(DISTINCT product_line) AS unique_product_lines FROM sales;

-- Best selling product line
SELECT product_line, SUM(quantity) AS total_sold FROM sales GROUP BY product_line ORDER BY total_sold DESC LIMIT 1;

-- Total revenue by month
SELECT MONTH(date) AS month, SUM(total) AS total_revenue FROM sales GROUP BY month ORDER BY month;

-- Month with largest COGS
SELECT MONTH(date) AS month, SUM(cogs) AS total_cogs FROM sales GROUP BY month ORDER BY total_cogs DESC LIMIT 1;

-- Product line with largest revenue
SELECT product_line, SUM(total) AS revenue FROM sales GROUP BY product_line ORDER BY revenue DESC LIMIT 1;

-- City with largest revenue
SELECT city, SUM(total) AS revenue FROM sales GROUP BY city ORDER BY revenue DESC LIMIT 1;

-- Product line with largest VAT
SELECT product_line, SUM(tax_pct * cogs) AS total_vat FROM sales GROUP BY product_line ORDER BY total_vat DESC LIMIT 1;

-- Product line performance classification
SELECT product_line, CASE WHEN SUM(total) > (SELECT AVG(total) FROM sales) THEN 'Good' ELSE 'Bad' END AS performance FROM sales GROUP BY product_line;

-- Branches selling more than average products
SELECT branch, SUM(quantity) AS total_sold FROM sales GROUP BY branch HAVING total_sold > (SELECT AVG(quantity) FROM sales);

-- Most common product line by gender
SELECT gender, product_line, COUNT(*) AS count FROM sales GROUP BY gender, product_line ORDER BY gender, count DESC;

-- Average rating per product line
SELECT product_line, AVG(rating) AS avg_rating FROM sales GROUP BY product_line ORDER BY avg_rating DESC;

-- Number of sales by time of day per weekday
SELECT DAYNAME(date) AS weekday, time, COUNT(*) AS sales FROM sales GROUP BY weekday, time ORDER BY weekday, time;

-- Customer type with most revenue
SELECT customer_type, SUM(total) AS total_revenue FROM sales GROUP BY customer_type ORDER BY total_revenue DESC LIMIT 1;

-- City with highest VAT percentage
SELECT city, AVG(tax_pct) AS avg_vat FROM sales GROUP BY city ORDER BY avg_vat DESC LIMIT 1;

-- Customer type paying most VAT
SELECT customer_type, SUM(tax_pct * cogs) AS total_vat FROM sales GROUP BY customer_type ORDER BY total_vat DESC LIMIT 1;

-- Unique customer types
SELECT COUNT(DISTINCT customer_type) AS unique_customer_types FROM sales;

-- Unique payment methods
SELECT COUNT(DISTINCT payment) AS unique_payment_methods FROM sales;

-- Most common customer type
SELECT customer_type, COUNT(*) AS count FROM sales GROUP BY customer_type ORDER BY count DESC LIMIT 1;

-- Customer type buying the most
SELECT customer_type, SUM(quantity) AS total_quantity FROM sales GROUP BY customer_type ORDER BY total_quantity DESC LIMIT 1;

-- Most common customer gender
SELECT gender, COUNT(*) AS count FROM sales GROUP BY gender ORDER BY count DESC LIMIT 1;

-- Gender distribution per branch
SELECT branch, gender, COUNT(*) AS count FROM sales GROUP BY branch, gender ORDER BY branch, gender;

-- Time of day with most ratings
SELECT time, AVG(rating) AS avg_rating FROM sales GROUP BY time ORDER BY avg_rating DESC LIMIT 1;

-- Time of day with most ratings per branch
SELECT branch, time, AVG(rating) AS avg_rating FROM sales GROUP BY branch, time ORDER BY branch, avg_rating DESC;

-- Best average rating day of the week
SELECT DAYNAME(date) AS weekday, AVG(rating) AS avg_rating FROM sales GROUP BY weekday ORDER BY avg_rating DESC LIMIT 1;

-- Best average rating per branch per weekday
SELECT branch, DAYNAME(date) AS weekday, AVG(rating) AS avg_rating FROM sales GROUP BY branch, weekday ORDER BY branch, avg_rating DESC;

