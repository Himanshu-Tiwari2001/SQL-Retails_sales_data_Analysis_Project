create DATABASE SqlProjects;
use SqlProjects;

CREATE TABLE `SQL_Retail_Sales_Analysis_utf` (
    transactions_id DECIMAL(38 , 0 ) NOT NULL,
    sale_date DATE NOT NULL,
    sale_time TIME NOT NULL,
    customer_id DECIMAL(38 , 0 ) NOT NULL,
    gender VARCHAR(6) NOT NULL,
    age DECIMAL(38 , 0 ),
    category VARCHAR(11) NOT NULL,
    quantiy DECIMAL(38 , 0 ),
    price_per_unit DECIMAL(38 , 0 ),
    cogs DECIMAL(38 , 2 ),
    total_sale DECIMAL(38 , 0 )
);
desc SQL_Retail_Sales_Analysis_utf;
drop table SQL_Retail_Sales_Analysis_utf;


LOAD DATA INFILE 'D:/SQL Projects/Sql Project 1 Retail Sales Analysis/SQL_Retail_Sales_Analysis_utf.csv'
    INTO TABLE SQL_Retail_Sales_Analysis_utf
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;
    
    -- to view the table
SELECT 
    *
FROM
    SQL_Retail_Sales_Analysis_utf;
SELECT 
    COUNT(transactions_id)
FROM
    SQL_Retail_Sales_Analysis_utf;-- 1997 records
   
SELECT 
    *
FROM
    SQL_Retail_Sales_Analysis_utf
WHERE
    transaction_id IS NULL
        OR sale_date IS NULL
        OR sale_time IS NULL
        OR gender IS NULL
        OR category IS NULL
        OR quantity IS NULL
        OR cogs IS NULL
        OR total_sale IS NULL;
    
    -- if there is any null value in the table  then we will have to delete it 
DELETE FROM SQL_Retail_Sales_Analysis_utf 
WHERE
    transaction_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR gender IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;
    
    
    rename table SQL_Retail_Sales_Analysis_utf to retail_sales;
    -- Data Exploration

SELECT 
    COUNT(*) AS total_sale
FROM
    retail_sales;

-- How many uniuque customers we have ?

SELECT 
    COUNT(DISTINCT customer_id) AS total_sale
FROM
    retail_sales;


-- My Analysis & Findings
SELECT 
    category, COUNT(category) AS count_of_category
FROM
    retail_sales
GROUP BY 1;
-- OR
SELECT 
    category, COUNT(category) AS count_of_category
FROM
    retail_sales
GROUP BY category;

SELECT 
    *
FROM
    retail_sales;

--  count the numbers of each categories in this data set  according to gender 
SELECT 
    gender, category, COUNT(category) AS count_of_each
FROM
    retail_sales
GROUP BY gender , category
ORDER BY gender;

-- calculate the total money spent by customer  in particular year gender wise
SELECT 
    gender AS Gender,
    SUM(total_sale) AS 'Money Spent',
    EXTRACT(YEAR FROM sale_date) AS year
FROM
    retail_sales
GROUP BY gender , EXTRACT(YEAR FROM sale_date);
    
-- calculate the total money spent by customer  in particular year in each categories 
SELECT 
    category AS Category,
    SUM(total_sale) AS 'Money Spent',
    EXTRACT(YEAR FROM sale_date) AS year
FROM
    retail_sales
GROUP BY category , EXTRACT(YEAR FROM sale_date);
     
     -- calculate the total money spent by customer  in particular year in each categories and  gender wise
	SELECT 
    COUNT(gender) AS Count,
    gender,
    category AS Category,
    SUM(total_sale) AS 'Money Spent',
    EXTRACT(YEAR FROM sale_date) AS year
FROM
    retail_sales
GROUP BY gender , category , EXTRACT(YEAR FROM sale_date)
ORDER BY year;
     
     -- calculate the  quantity of each category sold out in particular year in sorted(desc) 
SELECT 
    category AS 'Catrgories List',
    SUM(quantity) AS 'Total Qty Sold',
    EXTRACT(YEAR FROM sale_date) AS 'In Year'
FROM
    retail_sales
GROUP BY category , EXTRACT(YEAR FROM sale_date)
ORDER BY SUM(quantity) DESC;
      
--  here  I rename the quantity column 
--       ALTER TABLE retail_sales
--       RENAME COLUMN quantiy TO quantity;

      
	SELECT 
    *
FROM
    retail_sales;
    
      -- calculate the  quantity of each category sold out in particular year w.r.t gender
	SELECT 
    gender AS Gender,
    category AS 'Catrgories List',
    SUM(quantity) AS 'Total Qty Sold',
    EXTRACT(YEAR FROM sale_date) AS 'In Year'
FROM
    retail_sales
GROUP BY gender , category , EXTRACT(YEAR FROM sale_date)
ORDER BY EXTRACT(YEAR FROM sale_date) DESC;

     -- find the top 5 customer who shopping more often
SELECT 
    customer_id, COUNT(transactions_id) AS 'No of transactions'
FROM
    retail_sales
GROUP BY customer_id
ORDER BY COUNT(transactions_id) DESC
LIMIT 5;
     
     -- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
     
SELECT 
    *
FROM
    retail_sales
WHERE
    sale_date = '2022-11-05';
     
     -- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT 
    *
FROM
    retail_sales
WHERE
    category = 'Clothing' AND quantity >= 4
        AND sale_date LIKE '2022-11%';
     
     -- OR the same query will be written as 
SELECT 
    *
FROM
    retail_sales
WHERE
    category = 'Clothing'
        AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
        AND quantity >= 4;
        
 -- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.   
SELECT 
    category,
    SUM(total_sale) AS net_sale,
    COUNT(*) AS total_orders
FROM
    retail_sales
GROUP BY 1;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
    category, AVG(age)
FROM
    retail_sales
WHERE
    category = 'Beauty';
 
 -- Write a SQL query to find the average age of customers who purchased items from the each category.
SELECT 
    category, ROUND(AVG(age), 2) AS 'Average age'
FROM
    retail_sales
GROUP BY 1;
  
  -- Q.5 Write a SQL query to find top 10 transactions where the total_sale is greater than 1000.
SELECT 
    *
FROM
    retail_sales;
    
    
SELECT 
    *
FROM
    retail_sales
WHERE
    total_sale > 1000
ORDER BY total_sale DESC
LIMIT 10;
   
   -- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
    COUNT(transactions_id) AS 'Total Transactions',
    category,
    gender
FROM
    retail_sales
GROUP BY category , gender;
    
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT 
    year,
    month,
    avg_sale
FROM 
(
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank_in_year
    FROM retail_sales
    GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date)
) AS t1
WHERE rank_in_year = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT 
    customer_id, SUM(total_sale) AS total_sales
FROM
    retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.


SELECT 
    category,
    COUNT(DISTINCT customer_id) AS 'Count of unique customers'
FROM
    retail_sales
GROUP BY category;


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;
    
SELECT 
    *
FROM
    retail_sales;
    
   -- Calculate the percentage contribution of each category to the total sales (total_sale) for a specific year 2022/2023.
SELECT 
    category,
    (SUM(total_sale) * 100) / (SELECT 
            SUM(total_sale)
        FROM
            retail_sales
        WHERE
            EXTRACT(YEAR FROM sale_date) = 2022) AS 'Total Sales percentage',
    EXTRACT(YEAR FROM sale_date) AS Year
FROM
    retail_sales
GROUP BY category , EXTRACT(YEAR FROM sale_date)
HAVING Year = 2022;
    
    -- below query is used to calculate the total sales for year 2022 that i used as subquery in above query
SELECT 
    SUM(total_sale)
FROM
    retail_sales
WHERE
    EXTRACT(YEAR FROM sale_date) = 2022;
   
   
   -- Find the oldest customer who purchased from the 'Electronics' category and their transaction details.

SELECT 
    *
FROM
    retail_sales
WHERE
    category = 'Electronics'
        AND age = (SELECT 
            MAX(age)
        FROM
            retail_sales
        WHERE
            category = 'Electronics');
  
  -- Retrieve all transactions where the total sale was above the average total sale for that category in the corresponding year.
  
SELECT 
    *
FROM
    retail_sales
WHERE
    total_sale NOT IN (SELECT 
            category,
                AVG(total_sale),
                EXTRACT(YEAR FROM sale_date) AS Year
        FROM
            retail_sales
        GROUP BY category , Year);
  

SELECT 
    *
FROM
    retail_sales r
WHERE
    total_sale > (SELECT 
            AVG(total_sale)
        FROM
            retail_sales sub
        WHERE
            sub.category = r.category
                AND EXTRACT(YEAR FROM sub.sale_date) = EXTRACT(YEAR FROM r.sale_date)
        GROUP BY sub.category , EXTRACT(YEAR FROM sub.sale_date));

-- Identify the least popular category in terms of total sales for each month and year.
SELECT 
    category,
    EXTRACT(MONTH FROM sale_date) AS Month,
    EXTRACT(YEAR FROM sale_date) AS Year,
    SUM(total_sale) AS Total_sales
FROM
    retail_sales
GROUP BY category , Month , Year
ORDER BY Total_sales ASC
LIMIT 1;
 
  -- Calculate the year-over-year growth in total sales for each category.
SELECT 
    category,
    SUM(total_sale),
    EXTRACT(YEAR FROM sale_date) AS year
FROM
    retail_sales
GROUP BY category , year;
   
   -- or  
   -- this query automatically explain the growth and declination in sales of each category  but the above query result needs to be analyse manually by comparing the particular 
   WITH category_sales AS (
    SELECT 
        category, 
        EXTRACT(YEAR FROM sale_date) AS year, 
        SUM(total_sale) AS total_sales
    FROM 
        retail_sales
    GROUP BY 
        category, year
),
growth_calculation AS (
    SELECT 
        category,
        year,
        total_sales,
        LAG(total_sales) OVER (PARTITION BY category ORDER BY year) AS previous_year_sales
    FROM 
        category_sales
)
SELECT 
    category,
    year,
    total_sales,
    previous_year_sales,
    (total_sales - previous_year_sales) AS absolute_growth,
    ROUND(((total_sales - previous_year_sales) / previous_year_sales) * 100, 2) AS percentage_growth
FROM 
    growth_calculation
WHERE 
    previous_year_sales IS NOT NULL;
    

-- Write a query to identify transactions where the quantity sold exceeds the average quantity sold per transaction for the corresponding category.
SELECT 
    *
FROM
    retail_sales;


-- this query returns the result of average wrt corresponding category. we can use it as a another table and using join we can get the desired result
SELECT 
    category, AVG(quantity)
FROM
    retail_sales
GROUP BY category;

-- complete query

SELECT 
    t1.category,
    t1.transactions_id,
    t1.sale_date,
    t1.sale_time,
    t1.customer_id,
    t1.quantity,
    t2.avg_quantity
FROM
    retail_sales AS t1
        JOIN
    (SELECT 
        category, AVG(quantity) AS avg_quantity
    FROM
        retail_sales
    GROUP BY category) AS t2 ON t1.category = t2.category
WHERE
    t1.quantity > t2.avg_quantity;
    
    
-- Identify customers who made multiple transactions on the same day and retrieve their details.

  SELECT 
    customer_id,
    sale_date,
    COUNT(transactions_id) AS transaction_count
FROM 
    retail_sales
GROUP BY 
    customer_id, sale_date
HAVING 
    COUNT(transactions_id) > 1;
    
    
   -- Find the top-performing category for each gender in terms of average total sales per transaction.
   




SELECT 
    category, gender, AVG(total_sale)
FROM
    retail_sales
GROUP BY category , gender
ORDER BY AVG(total_sale) DESC
LIMIT 2; -- this also provide the result in this case but when top 2 result will from the same gender then it fails

WITH RankedSales AS (
    SELECT 
        category,
        gender,
        AVG(total_sale) AS avg_total_sale,
        RANK() OVER (PARTITION BY gender ORDER BY AVG(total_sale) DESC) AS ranked
    FROM 
        retail_sales
    GROUP BY 
        category, gender
)
SELECT 
    category, 
    gender, 
    avg_total_sale
FROM 
    RankedSales
WHERE 
    ranked = 1;

-- 9. Write a query to calculate the customer retention rate (percentage of customers who made transactions in multiple years).
WITH CustomerYearCount AS (
    SELECT 
        customer_id,
        COUNT(DISTINCT EXTRACT(YEAR FROM sale_date)) AS years_active
    FROM 
        retail_sales
    GROUP BY 
        customer_id
),
TotalCustomers AS (
    SELECT COUNT(*) AS total_customers FROM CustomerYearCount
),
RetainedCustomers AS (
    SELECT COUNT(*) AS retained_customers FROM CustomerYearCount WHERE years_active > 1
)
SELECT 
    (retained_customers * 100.0 / total_customers) AS retention_rate
FROM 
    RetainedCustomers, TotalCustomers;

-- 10. Calculate the average age of customers for each category and year and rank the categories by age group.
WITH AvgAge AS (
    SELECT 
        category,
        EXTRACT(YEAR FROM sale_date) AS year,
        AVG(age) AS avg_age
    FROM 
        retail_sales
    GROUP BY 
        category, year
)
SELECT 
    category,
    year,
    avg_age,
    RANK() OVER (PARTITION BY year ORDER BY avg_age DESC) AS ranked
FROM 
    AvgAge;

-- 11. Identify the category with the highest markup (difference between price per unit and cogs) and list the top 3 transactions for that category.
WITH Markup AS (
    SELECT 
        category,
        (price_per_unit - cogs) AS markup,
        transactions_id,
        total_sale
    FROM 
        retail_sales
)
SELECT 
    category,
    transactions_id,
    markup,
    total_sale
FROM 
    Markup
WHERE 
    category = (SELECT category FROM Markup ORDER BY markup DESC LIMIT 1)
ORDER BY 
    markup DESC
LIMIT 3;

-- 12. Determine the total number of transactions that occurred during the weekend (Saturday and Sunday).
SELECT 
    COUNT(*) AS total_weekend_transactions
FROM 
    retail_sales
WHERE 
    DAYOFWEEK(sale_date) IN (1, 7); -- 1 = Sunday, 7 = Saturday


-- 13. Retrieve the month with the highest sales (total_sale) for the top 3 categories with the highest annual total sales.
WITH AnnualSales AS (
    SELECT 
        category,
        SUM(total_sale) AS total_annual_sales
    FROM 
        retail_sales
    GROUP BY 
        category
    ORDER BY 
        total_annual_sales DESC
    LIMIT 3
),
MonthlySales AS (
    SELECT 
        category,
        EXTRACT(YEAR_MONTH FROM sale_date) AS year_Months,
        SUM(total_sale) AS monthly_sales
    FROM 
        retail_sales
    WHERE 
        category IN (SELECT category FROM AnnualSales)
    GROUP BY 
        category, year_Months
)
SELECT 
    category,
   year_Months,
    MAX(monthly_sales) AS max_sales
FROM 
    MonthlySales
GROUP BY 
    category, year_Months;

-- 14. Find transactions where the sale time is within the top 5 busiest hours across the entire dataset.
WITH HourlySales AS (
    SELECT 
        HOUR(sale_time) AS sale_hour,
        COUNT(*) AS transactions_count
    FROM 
        retail_sales
    GROUP BY 
        sale_hour
    ORDER BY 
        transactions_count DESC
    LIMIT 5
)
SELECT 
    *
FROM 
    retail_sales
WHERE 
    HOUR(sale_time) IN (SELECT sale_hour FROM HourlySales);


-- 15. Calculate the average total sale per transaction for customers aged between 18 and 25 across all categories.
SELECT 
    category,
    AVG(total_sale) AS avg_sale_per_transaction
FROM 
    retail_sales
WHERE 
    age BETWEEN 18 AND 25
GROUP BY 
    category;

-- 16. Retrieve all transactions where the total sale exceeds three times the cogs.
SELECT 
    *
FROM 
    retail_sales
WHERE 
    total_sale > 3 * cogs;

-- 17. Identify the customers who contributed to the top 10% of total sales for the entire dataset.
WITH TotalSales AS (
    SELECT 
        customer_id,
        SUM(total_sale) AS customer_sales
    FROM 
        retail_sales
    GROUP BY 
        customer_id
),
Top10PercentThreshold AS (
    SELECT 
        PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY customer_sales) AS threshold
    FROM 
        TotalSales
)
SELECT 
    customer_id, 
    customer_sales
FROM 
    TotalSales
WHERE 
    customer_sales >= (SELECT threshold FROM Top10PercentThreshold);

-- 18. Write a query to calculate the average sales per unit (price_per_unit) for each category in the dataset.
SELECT 
    category,
    AVG(price_per_unit) AS avg_sales_per_unit
FROM 
    retail_sales
GROUP BY 
    category;

-- 19. Calculate the total sales per hour for each category and identify the hour with the highest sales for each category.
WITH HourlySales AS (
    SELECT 
        category,
        HOUR(sale_time) AS sale_hour,
        SUM(total_sale) AS total_hourly_sales
    FROM 
        retail_sales
    GROUP BY 
        category, sale_hour
)
SELECT 
    category,
    sale_hour,
    MAX(total_hourly_sales) AS max_hourly_sales
FROM 
    HourlySales
GROUP BY 
    category, sale_hour;

-- 20. Find all transactions where the customer's age is greater than the average age of customers for their respective gender.
WITH AvgAgeByGender AS (
    SELECT 
        gender,
        AVG(age) AS avg_age
    FROM 
        retail_sales
    GROUP BY 
        gender
)
SELECT 
    rs.*
FROM 
    retail_sales rs
JOIN 
    AvgAgeByGender aag
ON 
    rs.gender = aag.gender
WHERE 
    rs.age > aag.avg_age;




  
 
 
 
 

   
   
   
   
   
   
   
   
   
   
   
   
   
   
  

   
 
 
 
 
     

     
     
     
     
     
     
     
     
     
     
	
     
     
     


    
    
    
    

