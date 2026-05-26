-- Gadget Sales Cleaning Project 

SELECT*
FROM sales_data_clean;

CREATE TABLE sales_data_clean AS
SELECT *
FROM sales_data;

-- Check for Duplicate in Column Order_ID

SELECT Order_ID, COUNT(*)
FROM sales_data_clean
GROUP BY order_ID
HAVING COUNT(*) > 1;

SELECT *
FROM sales_data_clean
WHERE order_id = 101;

-- find duplicate
SELECT order_ID, COUNT(*)
FROM sales_data_clean
GROUP BY order_id
HAVING COUNT(*) > 1;

-- to remove safe update mode
SET SQL_SAFE_UPDATES = 0;

-- Remove extra space
UPDATE sales_data_clean
SET customer_name = TRIM(customer_name);

-- Remove Duplicate Rows

CREATE TABLE sales_clean AS
SELECT DISTINCT *
FROM sales_data;

-- Verify Clean Table
DESCRIBE sales_clean;

-- View cleaned Record

SELECT *
FROM sales_clean
LIMIT 20;

-- Change column Names

ALTER TABLE sales_data_clean
RENAME COLUMN `customer name` TO customer_name;

-- Check for Null
SELECT *
FROM sales_data_clean
WHERE customer_name IS NULL
   OR region IS NULL;
   
ALTER TABLE sales_data_clean
CHANGE COLUMN `order_ID` TO Order_ID;

ALTER TABLE sales_data_clean
RENAME COLUMN `order_date` TO Order_Date;

ALTER TABLE sales_data_clean
RENAME COLUMN `ship date` TO Ship_Date;

ALTER TABLE sales_data_clean
RENAME COLUMN `customer_name` TO Customer_Name;

ALTER TABLE sales_data_clean
RENAME COLUMN `total price` TO Total_Price;


-- Remove Unneccessary/empty Columns

ALTER TABLE sales_data_clean
DROP COLUMN MyUnknownColumn;

ALTER TABLE sales_data_clean
DROP COLUMN `MyUnknownColumn_[0]`;


-- Convert Quality Column to Integer
ALTER TABLE sales_raw
MODIFY quantity INT;

-- Check for negative Quantities
SELECT*
FROM sales_data_clean
WHERE Quantity < 0;

DELETE FROM sales_data_clean
WHERE quantity < 0;

SELECT*
FROM sales_data_clean;

SET SQL_SAFE_UPDATES = 0;


-- Clean Price Column

UPDATE sales_data_clean
SET price = REPLACE(price, '$', '');

-- Convert to numerical datatype
ALTER TABLE sales_data_clean
MODIFY price DECIMAL(10,2);

-- Clean Date Columns
SELECT Order_Date
FROM your_table
WHERE COALESCE(
    STR_TO_DATE(Order_Date, '%M %e, %Y'),
    STR_TO_DATE(Order_Date, '%Y-%m-%d'),
    STR_TO_DATE(Order_Date, '%d/%m/%Y'),
    STR_TO_DATE(Order_Date, '%m/%d/%Y')
) IS NULL;

-- Change Datatype to Date
-- create a new date column
ALTER TABLE sale_data_clean
ADD COLUMN Order_Date DATE;

ALTER TABLE your_table
DROP COLUMN Order_Date;

ALTER TABLE your_table
CHANGE clean_order_date Order_Date DATE;

-- Identify the missing names
SELECT *
FROM sales_data_clean
WHERE Customer_Name IS NULL
   OR TRIM(Customer_Name) = '';
   

-- Replace missing names

UPDATE sales_data_clean
SET Customer_Name = 'Unknown Customer'
WHERE Customer_Name IS NULL
   OR TRIM(Customer_Name) = '';

   
-- Handle missing Regions

UPDATE sales_data_clean
SET Region = 'Unknown Region'
WHERE Region IS NULL
   OR TRIM(Region) = '';
         
-- Standardize date format
-- Add clean columns 
ALTER TABLE sales_data_clean
ADD COLUMN clean_order_date DATE,
ADD COLUMN clean_ship_date DATE;

-- Standardize order_date
UPDATE sales_data_clean
SET clean_order_date = COALESCE(
    STR_TO_DATE(Order_Date, '%M %e, %Y'),
    STR_TO_DATE(Order_Date, '%Y-%m-%d'),
    STR_TO_DATE(Order_Date, '%d/%m/%Y'),
    STR_TO_DATE(Order_Date, '%m/%d/%Y')
);
-- Remove all unwanted spaces and standardise total_price column

UPDATE sales_data_clean
SET Total_Price = REPLACE(Total_Price, '-', '');

-- Convert text to dates

ALTER TABLE sales_data_clean
CHANGE COLUMN `text` Order_Date DATE;


SELECT*
FROM sales_data_clean;
