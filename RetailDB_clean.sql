CREATE DATABASE RetailDB;
USE RetailDB;

CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category_id INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    stock_qty INT NOT NULL DEFAULT 0,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(80) NOT NULL,
    email VARCHAR(100) UNIQUE,
    city VARCHAR(50) DEFAULT 'Bengaluru',
    joined_date DATE DEFAULT (CURRENT_DATE)
);

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

ALTER TABLE customers ADD COLUMN phone VARCHAR(15);
ALTER TABLE customers ADD COLUMN loyalty_points INT DEFAULT 0;
ALTER TABLE customers MODIFY COLUMN phone VARCHAR(20);
ALTER TABLE customers RENAME COLUMN phone TO mobile_no;
ALTER TABLE customers DROP COLUMN mobile_no;

CREATE INDEX idx_products_name ON products(product_name);

CREATE TABLE feedback_temp (
    fb_id INT AUTO_INCREMENT PRIMARY KEY,
    comments VARCHAR(200) NOT NULL
);

INSERT INTO feedback_temp (comments) VALUES ('Helpful staff'), ('Quick delivery'), ('Good product quality');
TRUNCATE TABLE feedback_temp;
DROP TABLE feedback_temp;

DESCRIBE customers;
SHOW TABLES;

INSERT INTO categories (category_name) VALUES
('Groceries'), ('Personal Care'), ('Beverages'), ('Household');

INSERT INTO products (product_name, category_id, unit_price, stock_qty) VALUES
('Brown Rice 5kg', 1, 495.00, 75),
('Masoor Dal 1kg', 1, 155.00, 110),
('Groundnut Oil 1L', 1, 170.00, 55),
('Green Tea Pack', 3, 225.00, 40),
('Instant Coffee 500g', 3, 295.00, 48),
('Mango Juice 1L', 3, 125.00, 85),
('Aloe Vera Shampoo', 2, 210.00, 65),
('Herbal Soap Pack', 2, 135.00, 95),
('Dishwashing Gel', 4, 105.00, 80),
('Bathroom Cleaner 1L', 4, 185.00, 35);

INSERT INTO customers (full_name, email, city, joined_date) VALUES
('Arjun Menon', 'arjun.menon@example.com', 'Bengaluru', '2026-01-12'),
('Nisha Thomas', 'nisha.thomas@example.com', 'Kochi', '2026-02-18'),
('Aditya Verma', 'aditya.verma@example.com', 'Delhi', '2026-03-06'),
('Kavya Rao', 'kavya.rao@example.com', 'Chennai', '2026-03-24'),
('Rahul Das', 'rahul.das@example.com', 'Mumbai', '2026-04-11'),
('Pooja Reddy', 'pooja.reddy@example.com', 'Hyderabad', '2026-05-20'),
('Sanjay Kulkarni', 'sanjay.kulkarni@example.com', 'Pune', '2026-06-05'),
('Ishita Shah', 'ishita.shah@example.com', 'Bengaluru', '2026-06-28');

INSERT INTO orders (customer_id, order_date, status) VALUES
(1, '2026-07-05', 'Delivered'),
(2, '2026-07-12', 'Delivered'),
(3, '2026-08-02', 'Delivered'),
(1, '2026-08-10', 'Delivered'),
(4, '2026-08-15', 'Cancelled'),
(5, '2026-08-21', 'Delivered'),
(2, '2026-09-01', 'Delivered'),
(6, '2026-09-08', 'Pending'),
(3, '2026-09-15', 'Delivered'),
(7, '2026-09-22', 'Pending');

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 2), (1, 3, 1),
(2, 5, 2), (2, 4, 1),
(3, 2, 3), (3, 9, 2),
(4, 7, 1), (4, 8, 3),
(5, 1, 1), (5, 6, 4),
(6, 10, 2), (6, 9, 1),
(7, 2, 2), (7, 3, 2),
(8, 4, 2), (8, 5, 1),
(9, 8, 2), (9, 7, 2),
(10, 6, 6), (10, 1, 1);

INSERT INTO customers (full_name, email) VALUES ('Farhan Ali', 'farhan.ali@example.com');
SELECT * FROM customers WHERE full_name = 'Farhan Ali';

CREATE TABLE bengaluru_customers AS SELECT * FROM customers WHERE 1 = 0;
INSERT INTO bengaluru_customers SELECT * FROM customers WHERE city = 'Bengaluru';

SET SQL_SAFE_UPDATES = 1;
UPDATE products SET unit_price = 525.00 WHERE product_id = 1;

SET SQL_SAFE_UPDATES = 0;
UPDATE products SET unit_price = ROUND(unit_price * 1.05, 2) WHERE category_id = 1;
SET SQL_SAFE_UPDATES = 1;

INSERT INTO products (product_name, category_id, unit_price, stock_qty)
VALUES ('Almond Butter 500g', 1, 275.00, 32);

INSERT INTO orders (customer_id, order_date, status) VALUES (1, '2026-09-25', 'Pending');
SET @new_order = LAST_INSERT_ID();

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(@new_order, 2, 2),
(@new_order, 11, 1);

UPDATE products SET stock_qty = stock_qty - 2 WHERE product_id = 2;
UPDATE products SET stock_qty = stock_qty - 1 WHERE product_id = 11;

UPDATE orders SET status = 'Delivered' WHERE order_id = @new_order;
UPDATE customers SET loyalty_points = loyalty_points + 50 WHERE customer_id = 1;

DELETE FROM customers WHERE full_name = 'Farhan Ali' AND customer_id = 9;
DELETE FROM order_items WHERE order_id = 5;
DELETE FROM orders WHERE order_id = 5;
DROP TABLE bengaluru_customers;

SELECT * FROM products;
SELECT product_name, unit_price FROM products;
SELECT product_name, unit_price FROM products WHERE unit_price > 200;
SELECT product_name, unit_price FROM products WHERE unit_price BETWEEN 100 AND 200;
SELECT full_name, city FROM customers WHERE city IN ('Bengaluru', 'Delhi');
SELECT full_name FROM customers WHERE full_name LIKE 'A%';
SELECT product_name, unit_price FROM products ORDER BY unit_price DESC LIMIT 5;

SELECT product_name, unit_price * stock_qty AS stock_value
FROM products
ORDER BY stock_value DESC;

SELECT p.product_name, c.category_name, p.unit_price
FROM products p
JOIN categories c ON c.category_id = p.category_id;

SELECT o.order_id, o.order_date, cu.full_name, p.product_name,
       oi.quantity, p.unit_price,
       oi.quantity * p.unit_price AS line_amount
FROM orders o
JOIN customers cu ON cu.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p ON p.product_id = oi.product_id
ORDER BY o.order_id;

SELECT cu.customer_id, cu.full_name
FROM customers cu
LEFT JOIN orders o ON o.customer_id = cu.customer_id
WHERE o.order_id IS NULL;

SELECT product_name, unit_price
FROM products
WHERE unit_price > (SELECT AVG(unit_price) FROM products);

SELECT COUNT(*) AS total_products,
       SUM(stock_qty) AS total_units_in_stock,
       ROUND(AVG(unit_price), 2) AS average_price,
       MIN(unit_price) AS cheapest,
       MAX(unit_price) AS costliest
FROM products;

SELECT city, COUNT(*) AS customer_count
FROM customers
GROUP BY city
ORDER BY customer_count DESC;

SELECT status, COUNT(*) AS order_count
FROM orders
GROUP BY status;

SELECT c.category_name,
       COUNT(p.product_id) AS products,
       ROUND(AVG(p.unit_price), 2) AS avg_price,
       MIN(p.unit_price) AS min_price,
       MAX(p.unit_price) AS max_price
FROM categories c
JOIN products p ON p.category_id = c.category_id
GROUP BY c.category_name;

SELECT c.category_name,
       SUM(oi.quantity) AS units_sold,
       SUM(oi.quantity * p.unit_price) AS revenue
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
JOIN categories c ON c.category_id = p.category_id
WHERE o.status = 'Delivered'
GROUP BY c.category_name
ORDER BY revenue DESC;

SELECT cu.full_name,
       COUNT(DISTINCT o.order_id) AS orders_placed,
       SUM(oi.quantity * p.unit_price) AS total_spent
FROM customers cu
JOIN orders o ON o.customer_id = cu.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p ON p.product_id = oi.product_id
GROUP BY cu.full_name
ORDER BY total_spent DESC;

SELECT cu.full_name,
       SUM(oi.quantity * p.unit_price) AS total_spent
FROM customers cu
JOIN orders o ON o.customer_id = cu.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p ON p.product_id = oi.product_id
GROUP BY cu.full_name
HAVING SUM(oi.quantity * p.unit_price) > 1000
ORDER BY total_spent DESC;

SELECT cu.city, COUNT(o.order_id) AS delivered_orders
FROM customers cu
JOIN orders o ON o.customer_id = cu.customer_id
WHERE o.status = 'Delivered'
GROUP BY cu.city
HAVING COUNT(o.order_id) >= 2;

SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
       COUNT(DISTINCT o.order_id) AS orders,
       SUM(oi.quantity * p.unit_price) AS sales_amount
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE o.status <> 'Cancelled'
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY sales_month;

SELECT p.product_name, SUM(oi.quantity) AS units_sold
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY units_sold DESC
LIMIT 5;

CREATE USER 'sales_clerk'@'localhost' IDENTIFIED BY 'Clerk@123';
CREATE USER 'store_manager'@'localhost' IDENTIFIED BY 'Manager@123';

GRANT SELECT, INSERT ON RetailDB.orders TO 'sales_clerk'@'localhost';
GRANT SELECT, INSERT ON RetailDB.order_items TO 'sales_clerk'@'localhost';
GRANT SELECT ON RetailDB.products TO 'sales_clerk'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON RetailDB.* TO 'store_manager'@'localhost';

SHOW GRANTS FOR 'sales_clerk'@'localhost';

REVOKE INSERT ON RetailDB.order_items FROM 'sales_clerk'@'localhost';
REVOKE DELETE ON RetailDB.* FROM 'store_manager'@'localhost';

SHOW GRANTS FOR 'sales_clerk'@'localhost';
SHOW GRANTS FOR 'store_manager'@'localhost';

DROP USER 'sales_clerk'@'localhost';
DROP USER 'store_manager'@'localhost';

SET autocommit = 0;

START TRANSACTION;
UPDATE products SET stock_qty = stock_qty + 50 WHERE product_id = 4;
COMMIT;

START TRANSACTION;
UPDATE products SET unit_price = 1.00 WHERE product_id = 1;
SELECT product_id, product_name, unit_price FROM products WHERE product_id = 1;
ROLLBACK;
SELECT product_id, product_name, unit_price FROM products WHERE product_id = 1;

START TRANSACTION;
UPDATE customers SET loyalty_points = loyalty_points + 20 WHERE customer_id = 2;
SAVEPOINT after_points;
UPDATE customers SET city = 'Unknown' WHERE customer_id = 2;
SAVEPOINT after_city;
ROLLBACK TO SAVEPOINT after_points;
COMMIT;

SELECT customer_id, full_name, city, loyalty_points
FROM customers
WHERE customer_id = 2;

START TRANSACTION;
INSERT INTO orders (customer_id, order_date, status) VALUES (3, '2026-09-29', 'Pending');
SET @o = LAST_INSERT_ID();
INSERT INTO order_items (order_id, product_id, quantity) VALUES (@o, 5, 2);
UPDATE products SET stock_qty = stock_qty - 2 WHERE product_id = 5;
COMMIT;

SET autocommit = 1;
