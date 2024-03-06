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







