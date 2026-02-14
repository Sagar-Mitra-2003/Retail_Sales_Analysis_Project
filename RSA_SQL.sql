## Creating Database
CREATE DATABASE Project;
USE Project;

## Importing Dataset using Wizard
SELECT * FROM SuperStore;

## STEP 1 : Understanding Table Properly
DESCRIBE SuperStore;

SELECT COUNT(*) AS total_rows FROM SuperStore;

# Checking Null  values
SELECT COUNT(*) AS total_rows,
SUM(Row_ID IS NULL) AS ID_null,
SUM(Sales IS NULL) AS sales_null,
SUM(Profit IS NULL) AS profit_null,
SUM(Discount IS NULL) AS discount_null
FROM SuperStore;

## STEP 2: Business KPI Queries

# Total Revenue
SELECT ROUND(SUM(Sales),2) AS Total_Sales FROM SuperStore;

# Total Profit
SELECT ROUND(SUM(Profit),2) AS Total_Profit FROM SuperStore;

# Total Order
SELECT COUNT('Order ID') AS Total_Order FROM SuperStore;

# Total Quantity Sold
SELECT SUM(Quantity) AS Total_quantity FROM SuperStore;

# Profit Margin %
SELECT ROUND((SUM(Profit)/SUM(Sales)*100),2) AS Total_Profit_Margin FROM SuperStore;

## STEP 3 : Time Analysis (Sales Trend & Growth)

# Monthly Sales Trend
SELECT Order_Month,
ROUND(SUM(Sales),2) AS monthly_sales
FROM SuperStore
GROUP BY Order_Month
ORDER BY monthly_sales DESC;

# Monthly Profit Trend
SELECT Order_Month,
ROUND(SUM(Profit),2) AS monthly_profit
FROM SuperStore
GROUP BY Order_Month
ORDER BY monthly_profit DESC;

# Monthly Order Volume
SELECT Order_Month,
COUNT(Order_ID) AS monthly_order
FROM SuperStore
GROUP BY Order_Month
ORDER BY monthly_order DESC;

# Monthly Profit Margin %
SELECT Order_Month,
ROUND(SUM(Profit)/SUM(Sales)*100,2) AS profit_margin
FROM SuperStore
GROUP BY Order_Month
ORDER BY profit_margin DESC;

## STEP 4 : Region Analysis

# Sales by Region
SELECT Region,
ROUND(SUM(Sales),2) AS total_sales
FROM SuperStore
GROUP BY Region
ORDER BY total_sales DESC;

# Profit by Region
SELECT Region,
ROUND(SUM(Profit),2) AS monthly_profit
FROM SuperStore
GROUP BY Region
ORDER BY monthly_profit DESC;

# Order Volume by Region
SELECT Region,
COUNT(Order_ID) AS monthly_order
FROM SuperStore
GROUP BY Region
ORDER BY monthly_order DESC;

# Profit Margin % by Region
SELECT Region,
ROUND(SUM(Profit)/SUM(Sales)*100,2) AS profit_margin
FROM SuperStore
GROUP BY Region
ORDER BY profit_margin DESC;

## STEP 5 : Product & Category Analysis

# Sales by Category
SELECT Category,
ROUND(SUM(Sales),2) AS total_sales
FROM SuperStore
GROUP BY Category
ORDER BY total_sales DESC;

# Profit by Category
SELECT Category,
ROUND(SUM(Profit),2) AS monthly_profit
FROM SuperStore
GROUP BY Category
ORDER BY monthly_profit DESC;

# Profit Margin % by Category
SELECT Category,
ROUND(SUM(Profit)/SUM(Sales)*100,2) AS profit_margin
FROM SuperStore
GROUP BY Category
ORDER BY profit_margin DESC;

# Top 10 Profitable Products
SELECT Product_Name,
ROUND(SUM(Profit),2) AS monthly_profit
FROM SuperStore
GROUP BY Product_Name
ORDER BY monthly_profit DESC
LIMIT 10;

# Top 10 Loss Making Products
SELECT Product_Name,
ROUND(SUM(Profit),2) AS monthly_profit
FROM SuperStore
GROUP BY Product_Name
ORDER BY monthly_profit
LIMIT 10;

# Sub-Category Performance
SELECT Sub_Category,
ROUND(SUM(Sales),2) AS monthly_sales,
ROUND(SUM(Profit),2) AS monthly_profit
FROM SuperStore
GROUP BY Sub_Category
ORDER BY monthly_profit DESC;

## STEP 6 : Customer Analysis & Segmentation

# Top 10 Customers by Sales
SELECT Customer_Name,
ROUND(SUM(Sales),2) AS total_sales
FROM SuperStore
GROUP BY Customer_Name
ORDER BY total_sales DESC
LIMIT 10;

# Top 10 Customers by Profit
SELECT Customer_Name,
ROUND(SUM(Profit),2) AS monthly_profit
FROM SuperStore
GROUP BY Customer_Name
ORDER BY monthly_profit DESC
LIMIT 10;

# Customer Order Frequency
SELECT Customer_Name,
COUNT(Order_ID) AS total_order
FROM SuperStore
GROUP BY Customer_Name
ORDER BY total_order DESC
LIMIT 10;

# Customer Segmentation (High / Medium / Low Value)
SELECT Customer_Name,
ROUND(SUM(Sales),2) AS total_spent,
CASE
	WHEN SUM(Sales)>10000 THEN "High Value"
	WHEN SUM(Sales)>5000 THEN "Medium Value"
	ELSE "Low Value"
END AS Customer_Segment
FROM SuperStore
GROUP BY Customer_Name
ORDER BY total_spent DESC;

# Count Customers in Each Segment
SELECT Customer_Segment,
COUNT(*) AS total_customer
FROM (
	SELECT Customer_Name,
	ROUND(SUM(Sales),2) AS total_spent,
	CASE
		WHEN SUM(Sales)>10000 THEN "High Value"
		WHEN SUM(Sales)>5000 THEN "Medium Value"
		ELSE "Low Value"
	END AS Customer_Segment
	FROM SuperStore
	GROUP BY Customer_Name
	) CS #Every derived table must have its own alias
GROUP BY Customer_Segment;

## STEP 7 : Advanced Analysis (Window Functions & Business Logic)

# Top Customers Ranking by Sales
SELECT Customer_Name,
ROUND(SUM(Sales),2) AS total_sales,
RANK() OVER (ORDER BY SUM(Sales) DESC) AS sales_rank
FROM SuperStore
GROUP BY Customer_Name;

# Running Total of Sales (Cumulative Sales Over Time)
SELECT Order_Month,
ROUND(SUM(Sales),2) AS total_sales,
ROUND(SUM(SUM(Sales)) OVER (ORDER BY Order_Month)) AS commulative_sales
FROM SuperStore
GROUP BY Order_Month
ORDER BY Order_Month;

# Contribution % by Category
SELECT category,
ROUND(SUM(sales),2) AS total_sales,
ROUND(SUM(sales) * 100 / SUM(SUM(sales)) OVER (),2) AS contribution_percent
FROM superstore
GROUP BY category
ORDER BY contribution_percent DESC;

# Top 3 Products in Each Category (Advanced Ranking)
SELECT * FROM (
SELECT Category, Product_Name,
ROUND(SUM(Profit),2) AS total_profit,
RANK() OVER (PARTITION BY Category ORDER BY SUM(Profit) DESC) AS rank_in_category
FROM SuperStore
GROUP BY Category, Product_Name 
) r_i_c
WHERE rank_in_category <=3;

