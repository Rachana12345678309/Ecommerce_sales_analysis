
CREATE DATABASE ecommerce_sales_data
USE ecommerce_sales_data;
SELECT * FROM Sales_Dataset_New;


--Q1) Identify the top three states with the highest shipping costs sum

SELECT TOP 3 state, sum(shipping_cost) AS total_shipping_cost
FROM Sales_Dataset_New
GROUP BY state
ORDER BY total_shipping_cost DESC;



--Q2)Identifying the premium customers - i.e - whose total_quantity > avg_quantity bought
USE ecommerce_sales_data;  -- Select the specific database to work with

-- First CTE: Calculate total quantity purchased by each customer per region
WITH CustomerQuantity AS
(
     SELECT 
         customer_name,   -- Identify individual customers
         region,          -- Group results by region
         SUM(quantity) as TotalQuantity  -- Sum up total items purchased by each customer
     FROM Sales_Dataset_NEW
     GROUP BY customer_name, region  -- Create unique customer-region combinations
),
 
-- Second CTE: Calculate the average total quantity across all customers
AverageQuantity AS (
    SELECT AVG(TotalQuantity) as AvgQuantity  -- Compute the mean of total quantities
    FROM CustomerQuantity 
)

-- Main Query: Select premium customers who purchase more than average
SELECT
    (SELECT TOP 1 AvgQuantity FROM AverageQuantity) AS AverageQuantityThreshold,  -- Display the average quantity threshold
    cq.customer_name,    -- Show the customer's name
    cq.region,           -- Show the customer's region
    sd.category,         -- Show product category
    sd.sub_category,     -- Show product sub-category
    cq.TotalQuantity     -- Show total quantity purchased by the customer
FROM CustomerQuantity cq
JOIN 
    Sales_Dataset_NEW sd ON sd.customer_name = cq.customer_name  -- Link customer quantity with original sales data
CROSS JOIN
    AverageQuantity aq  -- Join with average quantity to enable comparison
WHERE cq.TotalQuantity > aq.AvgQuantity  -- Filter for customers buying more than average
GROUP BY
    cq.customer_name,    -- Group results to handle potential multiple entries
    cq.region,
    sd.category,
    sd.sub_category,
    cq.TotalQuantity
ORDER BY cq.TotalQuantity DESC;  -- Sort results from highest to lowest quantity
	





