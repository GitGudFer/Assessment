/* First of all, let's take a look at the imported cleaned table, and correct the identifier to begin with 1 */
SELECT *
FROM TRANSACTIONS_CLEANED;

UPDATE transactions_cleaned
SET identifier = identifier + 1;


/*  Now, we will make the dimension and fact tables taking the columns from the whole dataset */

CREATE OR REPLACE TABLE Client AS 
SELECT identifier, client_id, client_name, client_lastname, email
FROM transactions_cleaned;

CREATE OR REPLACE TABLE Store AS 
SELECT identifier, store_id, store_name, location
FROM transactions_cleaned;

CREATE OR REPLACE TABLE Product AS 
SELECT IDENTIFIER, product_id, product_name, category, brand
FROM transactions_cleaned;

CREATE OR REPLACE TABLE Address AS 
SELECT IDENTIFIER, address_id, street, city, state, zip_code
FROM transactions_cleaned;

CREATE OR REPLACE TABLE Sales AS 
SELECT IDENTIFIER, client_id, store_id, product_id, address_id, transaction_id, quantity_of_items_sold, unit_price, discount
FROM transactions_cleaned;


/* Now that we have all the tables we need, we can query some metrics from them */

/*Metrics*/

--Total sales
SELECT SUM(quantity_of_items_sold*unit_price) AS total_revenue, SUM(quantity_of_items_sold*unit_price*(1-discount)) AS total_net_revenue
FROM sales;


-- Number of Clients
SELECT COUNT(DISTINCT client_id) AS num_client
FROM client;

-- Transactions per client
SELECT client_id, COUNT(DISTINCT transaction_id) AS num_transactions
FROM Sales
GROUP BY client_id
ORDER BY num_transactions DESC;

-- Total spend per client
SELECT client_id, SUM(quantity_of_items_sold * unit_price) AS total_spend
FROM Sales
GROUP BY client_id
ORDER BY total_spend DESC;


-- Sales by store
SELECT COUNT(DISTINCT store_id) AS num_stores
FROM Store;

SELECT st.store_id, st.store_name, SUM(quantity_of_items_sold * unit_price) AS total_sales_amount
FROM Sales s
JOIN Store st ON s.identifier = st.identifier
GROUP BY st.store_id, st.store_name
ORDER BY total_sales_amount DESC;


--Products
-- Sales by product
SELECT DISTINCT product_id, product_name
FROM product;

SELECT p.product_id, p.product_name, SUM(s.quantity_of_items_sold) AS total_quantity_sold
FROM Sales s
JOIN Product p ON s.identifier = p.identifier
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 5;


-- Sales by category
SELECT p.category, SUM(s.quantity_of_items_sold * s.unit_price) AS total_sales_amount
FROM Sales s
JOIN Product p ON s.identifier = p.identifier
GROUP BY p.category
ORDER BY total_sales_amount DESC;


-- Sales by cities
SELECT a.city, SUM(s.quantity_of_items_sold * s.unit_price) AS total_sales_amount
FROM Sales s
JOIN Address a ON s.identifier = a.identifier
GROUP BY a.city
ORDER BY total_sales_amount DESC
LIMIT 5;


-- Sales by state
SELECT DISTINCT state
FROM address;

SELECT a.state, SUM(s.quantity_of_items_sold * s.unit_price) AS total_sales_amount
FROM Sales s
JOIN Address a ON s.identifier = a.identifier
GROUP BY a.state
ORDER BY total_sales_amount DESC;

