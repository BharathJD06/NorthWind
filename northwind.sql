-- ================================
-- INITIAL SETUP
-- ================================
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;

DROP SCHEMA IF EXISTS northwind;
CREATE SCHEMA northwind DEFAULT CHARACTER SET utf8mb4;
USE northwind;

-- ================================
-- TABLES
-- ================================

CREATE TABLE customers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  company VARCHAR(50),
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  city VARCHAR(50),
  country_region VARCHAR(50)
);

CREATE TABLE employees (
  id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50)
);

CREATE TABLE products (
  id INT AUTO_INCREMENT PRIMARY KEY,
  product_name VARCHAR(50),
  list_price DECIMAL(10,2)
);

CREATE TABLE orders (
  id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT,
  employee_id INT,
  order_date DATETIME,
  FOREIGN KEY (customer_id) REFERENCES customers(id),
  FOREIGN KEY (employee_id) REFERENCES employees(id)
);

CREATE TABLE order_details (
  id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT,
  product_id INT,
  quantity INT,
  unit_price DECIMAL(10,2),
  FOREIGN KEY (order_id) REFERENCES orders(id),
  FOREIGN KEY (product_id) REFERENCES products(id)
);

-- ================================
-- HELPER: NUMBER GENERATOR (1–3000)
-- ================================
CREATE TABLE numbers (n INT);

INSERT INTO numbers (n)
SELECT a.N + b.N*10 + c.N*100 + d.N*1000 + 1
FROM 
(SELECT 0 N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
(SELECT 0 N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b,
(SELECT 0 N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) c,
(SELECT 0 N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3) d
WHERE a.N + b.N*10 + c.N*100 + d.N*1000 < 3000;

-- ================================
-- INSERT DATA
-- ================================

-- CUSTOMERS (3000)
INSERT INTO customers (company, first_name, last_name, city, country_region)
SELECT 
  CONCAT('Company_', n),
  CONCAT('First_', n),
  CONCAT('Last_', n),
  ELT(1 + FLOOR(RAND()*5), 'Toronto','Vancouver','Montreal','Calgary','Ottawa'),
  'Canada'
FROM numbers;

-- EMPLOYEES (50)
INSERT INTO employees (first_name, last_name)
SELECT 
  CONCAT('EmpFirst_', n),
  CONCAT('EmpLast_', n)
FROM numbers
WHERE n <= 50;

-- PRODUCTS (200)
INSERT INTO products (product_name, list_price)
SELECT 
  CONCAT('Product_', n),
  ROUND(10 + RAND()*490, 2)
FROM numbers
WHERE n <= 200;

-- ORDERS (3000)
INSERT INTO orders (customer_id, employee_id, order_date)
SELECT 
  FLOOR(1 + RAND()*3000),
  FLOOR(1 + RAND()*50),
  NOW() - INTERVAL FLOOR(RAND()*365) DAY
FROM numbers;

-- ORDER DETAILS (~6000 rows)
INSERT INTO order_details (order_id, product_id, quantity, unit_price)
SELECT 
  FLOOR(1 + RAND()*3000),
  FLOOR(1 + RAND()*200),
  FLOOR(1 + RAND()*10),
  ROUND(10 + RAND()*490, 2)
FROM numbers
UNION ALL
SELECT 
  FLOOR(1 + RAND()*3000),
  FLOOR(1 + RAND()*200),
  FLOOR(1 + RAND()*10),
  ROUND(10 + RAND()*490, 2)
FROM numbers;
-- ================================
-- SETUP
-- ================================
SET FOREIGN_KEY_CHECKS=0;

DROP DATABASE IF EXISTS retail_analytics;
CREATE DATABASE retail_analytics;
USE retail_analytics;

-- ================================
-- TABLES
-- ================================

CREATE TABLE customers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  city VARCHAR(50),
  country VARCHAR(50),
  signup_date DATE
);

CREATE TABLE employees (
  id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  role VARCHAR(50)
);

CREATE TABLE categories (
  id INT AUTO_INCREMENT PRIMARY KEY,
  category_name VARCHAR(50)
);

CREATE TABLE products (
  id INT AUTO_INCREMENT PRIMARY KEY,
  product_name VARCHAR(100),
  category_id INT,
  price DECIMAL(10,2),
  FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE orders (
  id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT,
  employee_id INT,
  order_date DATE,
  status VARCHAR(20),
  FOREIGN KEY (customer_id) REFERENCES customers(id),
  FOREIGN KEY (employee_id) REFERENCES employees(id)
);

CREATE TABLE order_details (
  id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT,
  product_id INT,
  quantity INT,
  unit_price DECIMAL(10,2),
  FOREIGN KEY (order_id) REFERENCES orders(id),
  FOREIGN KEY (product_id) REFERENCES products(id)
);

-- ================================
-- NUMBER GENERATOR (1–10000)
-- ================================
CREATE TABLE numbers (n INT);

INSERT INTO numbers (n)
SELECT a.N + b.N*10 + c.N*100 + d.N*1000 + e.N*10000 + 1
FROM 
(SELECT 0 N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
(SELECT 0 N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b,
(SELECT 0 N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) c,
(SELECT 0 N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) d,
(SELECT 0 N UNION SELECT 1) e
WHERE a.N + b.N*10 + c.N*100 + d.N*1000 + e.N*10000 < 10000;

-- ================================
-- INSERT DATA
-- ================================

-- CUSTOMERS (10,000)
INSERT INTO customers (first_name, last_name, city, country, signup_date)
SELECT 
  CONCAT('First_', n),
  CONCAT('Last_', n),
  ELT(1 + FLOOR(RAND()*6), 'Toronto','Vancouver','Montreal','Calgary','Ottawa','Edmonton'),
  'Canada',
  CURDATE() - INTERVAL FLOOR(RAND()*1000) DAY
FROM numbers;

-- EMPLOYEES (200)
INSERT INTO employees (first_name, last_name, role)
SELECT 
  CONCAT('Emp_', n),
  CONCAT('Last_', n),
  ELT(1 + FLOOR(RAND()*3), 'Sales Rep','Manager','Support')
FROM numbers
WHERE n <= 200;

-- CATEGORIES (10)
INSERT INTO categories (category_name)
VALUES 
('Electronics'),('Clothing'),('Home'),('Sports'),('Beauty'),
('Toys'),('Automotive'),('Books'),('Groceries'),('Health');

-- PRODUCTS (500)
INSERT INTO products (product_name, category_id, price)
SELECT 
  CONCAT('Product_', n),
  FLOOR(1 + RAND()*10),
  ROUND(5 + RAND()*495,2)
FROM numbers
WHERE n <= 500;

-- ORDERS (10,000)
INSERT INTO orders (customer_id, employee_id, order_date, status)
SELECT 
  FLOOR(1 + RAND()*10000),
  FLOOR(1 + RAND()*200),
  CURDATE() - INTERVAL FLOOR(RAND()*365) DAY,
  ELT(1 + FLOOR(RAND()*3), 'Completed','Pending','Cancelled')
FROM numbers;

-- ORDER DETAILS (~30,000)
INSERT INTO order_details (order_id, product_id, quantity, unit_price)
SELECT 
  FLOOR(1 + RAND()*10000),
  FLOOR(1 + RAND()*500),
  FLOOR(1 + RAND()*5),
  ROUND(5 + RAND()*495,2)
FROM numbers
UNION ALL
SELECT 
  FLOOR(1 + RAND()*10000),
  FLOOR(1 + RAND()*500),
  FLOOR(1 + RAND()*5),
  ROUND(5 + RAND()*495,2)
FROM numbers
UNION ALL
SELECT 
  FLOOR(1 + RAND()*10000),
  FLOOR(1 + RAND()*500),
  FLOOR(1 + RAND()*5),
  ROUND(5 + RAND()*495,2)
FROM numbers;

-- CLEANUP
DROP TABLE numbers;

SET FOREIGN_KEY_CHECKS=1;