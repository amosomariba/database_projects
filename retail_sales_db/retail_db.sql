USE retail_db;

SELECT * FROM retails_tb;

-- check how many rows are in the retail_db
SELECT COUNT(*) FROM retails_tb;


-- check null values in the db
SELECT * 
FROM retails_tb
WHERE transaction_id IS NULL
OR
customer_id IS NULL
OR
gender IS NULL
OR
age IS NULL
OR
category IS NULL
OR
quantity IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL
OR
sale_date IS NULL
OR
sale_time IS NULL;

-- data cleaning
-- check if quantity has 0 value
SELECT * FROM retails_tb
WHERE quantity = 0;

DELETE FROM retails_tb
WHERE transaction_id IS NULL
OR
customer_id IS NULL
OR
gender IS NULL
OR
age IS NULL
OR
category IS NULL
OR
quantity IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL
OR
sale_date IS NULL
OR
sale_time IS NULL;

DELETE FROM retails_tb
WHERE quantity =0;

-- DATA EXPLORATION

-- check, how many sales were there?

SELECT COUNT(*) AS total_sales FROM retails_tb;

-- how many customers we have?(unique customers)
SELECT COUNT(DISTINCT customer_id) AS unique_customers 
FROM retails_tb;

-- unique categories
SELECT DISTINCT category FROM retails_tb; 
  
-- retrieving all sales made on  '2022-11-05'
SELECT * FROM retails_tb
where sale_date = '2022-11-05';

-- retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
 SELECT * FROM retails_tb
 WHERE category = 'Clothing'
 AND quantity >=4
 AND sale_date BETWEEN '2022-11-1' AND '2022-11-30';
 
 -- sum of the total quantity
 SELECT category,
	SUM(quantity) AS total_quantity
FROM retails_tb
GROUP BY category;

-- calculate the total sales (total_sale) for each category
SELECT category,
SUM(total_sale) AS total_sales_each_category,
COUNT(*) as total_orders
FROM retails_tb
GROUP BY category; 

-- find the average age of customers who purchased items from the 'Beauty' category
SELECT
ROUND(AVG(age),1) AS avg_age_beauty_category
FROM retails_tb
WHERE category = 'Beauty';

-- average age of each category
SELECT
category,
ROUND(AVG(age),1) AS avg_age_category
FROM retails_tb
GROUP BY category
;

--  find all transactions where the total_sale is greater than 1000
SELECT *
FROM retails_tb
WHERE total_sale > 1000;

-- find the total number of transactions (transaction_id) made by each gender in each category.
SELECT
gender,
category,
COUNT(*) AS transanctions
FROM retails_tb
GROUP BY gender,
		category
ORDER BY category
;

--  calculate the average sale for each month. Find out best selling month in each year
 SELECT
    YEAR(sale_date) AS year,
    MONTH(sale_date) AS month,
    ROUND(AVG(total_sale), 2) AS average_sale,
    ROUND(SUM(total_sale), 2) AS total_revenue
FROM retails_tb
GROUP BY year, month
ORDER BY year, 3 DESC;

WITH monthly_sales AS (
    SELECT
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        ROUND(SUM(total_sale), 2) AS total_sales
    FROM retails_tb
    GROUP BY year, month
)

SELECT *
FROM (
    SELECT *,
           RANK() OVER(PARTITION BY year ORDER BY total_sales DESC) AS ranking
    FROM monthly_sales
) ranked_sales
WHERE ranking = 1;

--  find the top 5 customers based on the highest total sales 
SELECT 
	customer_id,
    gender,
    SUM(total_sale) AS sum_total_sales
FROM retails_tb
GROUP BY customer_id,gender
ORDER BY sum_total_sales DESC
LIMIT 5;

-- find the number of unique customers who purchased items from each category
SELECT 
category,
COUNT(DISTINCT customer_id) AS unique_customers
FROM retails_tb
GROUP BY category
ORDER BY unique_customers DESC;

-- create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retails_tb
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift

-- END -- 

