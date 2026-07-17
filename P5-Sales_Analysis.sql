-- Sales Analysis;

-- Concepts used : Windows functions, CTE (Common Table Expressions)

CREATE DATABASE sales_analysis;
USE sales_analysis;

CREATE TABLE customers(
customer_id INT PRIMARY KEY,
name VARCHAR(100),
city VARCHAR(50)
);

CREATE TABLE products(
product_id INT PRIMARY KEY,
product_name VARCHAR(100),
price DECIMAL(10, 2)
);

CREATE TABLE sales(
sale_id INT PRIMARY KEY,
customer_id INT,
amount DECIMAL (10, 2),
sale_date DATE,
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id)
);

CREATE TABLE order_items(
order_item_id INT PRIMARY KEY,
sale_id INT,
product_id INT,
quantity INT,
FOREIGN KEY (sale_id)
REFERENCES sales(sale_id),
FOREIGN KEY (product_id)
REFERENCES products(product_id)
);

## data insert;

INSERT INTO customers VALUES
(135, 'Jogindar', 'Panipat'),
(246, 'Sharon', 'Patna'),
(357, 'Samay', 'Kashmir'),
(468, 'Gopi Bahu', 'Mumbai'),
(579, 'Anandi', 'Jaisalmer');

INSERT INTO products VALUES
(010, 'Laptop', 75000),
(020, 'Microphone', 8500),
(030, 'PC', 125000),
(040, 'Barbie Phone', 1250),
(050, 'Pottery', 3500);

INSERT INTO sales VALUES
(123, 579, 3500, '2026-01-01'),
(234, 468, 75000, '2026-03-05'),
(345, 357, 125000, '2026-05-09'),
(456, 246, 8500, '2026-07-15'),
(567, 135, 1250, '2026-09-20');

INSERT INTO order_items VALUES
(1010, 123, 050, 15),
(2020, 234, 010, 5),
(3030, 345, 030, 2),
(4040, 456, 020, 8),
(5050, 567, 040, 20),
(6060, 456, 010, 2),
(7070, 234, 030, 1),
(8080, 123, 050, 25),
(9090, 345, 020, 5); 

## to see complete sales data, I'll have to use JOINs to compile all tables;

SELECT c.name, p.product_name, oi.quantity, p.price AS price_per_unit, p.price * oi.quantity AS total_amount, s.sale_date
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
JOIN order_items oi ON s.sale_id = oi.sale_id
JOIN products p ON oi.product_id = p.product_id;

## to check the total revenue;

SELECT SUM(p.price * oi.quantity) as total_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id;

## to check top 3 customers;

SELECT name, total_spent
FROM(
SELECT c.name, SUM(p.price * oi.quantity) AS total_spent,
RANK() OVER (ORDER BY SUM(p.price * oi.quantity) DESC) AS rnk
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
JOIN order_items oi ON s.sale_id = oi.sale_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY c.name
)ranked
WHERE rnk<=3;

## date-wise revenue trend;

SELECT s.sale_date, SUM(p.price * oi.quantity) AS date_wise_revenue
FROM sales s
JOIN order_items oi ON s.sale_id = s.sale_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY s.sale_date
ORDER BY s.sale_date;


