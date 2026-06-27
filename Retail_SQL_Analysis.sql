SELECT
ROUND(SUM(sales),2) AS Total_Sales
FROM retail_sales;


SELECT
    ROUND(SUM(profit), 2) AS Total_Profit
FROM retail_sales;


SELECT
    COUNT(DISTINCT order_id) AS Total_Orders
FROM retail_sales;


SELECT
    COUNT(DISTINCT customer_id) AS Total_Customers
FROM retail_sales;


SELECT
    ROUND(
        SUM(sales) / COUNT(DISTINCT order_id),
        2
    ) AS Average_Order_Value
FROM retail_sales;



SELECT
    ROUND(
        (SUM(profit) / SUM(sales)) * 100,
        2
    ) AS Profit_Margin_Percentage
FROM retail_sales;


SELECT
    ROUND(AVG(discount) * 100, 2) AS Average_Discount_Percentage
FROM retail_sales;



-- ===================================
-- Query 8 : Monthly Sales Trend
-- ===================================

SELECT
    order_year,
    order_month,
    ROUND(SUM(sales),2) AS Total_Sales
FROM retail_sales
GROUP BY
    order_year,
    order_month
ORDER BY
    order_year,
    FIELD(order_month,
        'January','February','March','April','May','June',
        'July','August','September','October','November','December');
        
        
        -- ===================================
-- Query 9 : Sales by Category
-- ===================================

SELECT
    category,
    ROUND(SUM(sales),2) AS Total_Sales
FROM retail_sales
GROUP BY category
ORDER BY Total_Sales DESC;


-- ===================================
-- Query 10 : Top 10 Products
-- ===================================

SELECT
    product_name,
    ROUND(SUM(sales),2) AS Total_Sales
FROM retail_sales
GROUP BY product_name
ORDER BY Total_Sales DESC
LIMIT 10;


SELECT
    order_year,
    order_quarter,
    ROUND(SUM(sales),2) AS Total_Sales
FROM retail_sales
GROUP BY
    order_year,
    order_quarter
ORDER BY
    order_year,
    order_quarter;
    
    
    
    SELECT
    customer_name,
    ROUND(SUM(sales),2) AS Total_Sales
FROM retail_sales
GROUP BY customer_name
ORDER BY Total_Sales DESC
LIMIT 10;



SELECT
    segment,
    ROUND(SUM(sales),2) AS Total_Sales,
    ROUND(SUM(profit),2) AS Total_Profit
FROM retail_sales
GROUP BY segment
ORDER BY Total_Sales DESC;



SELECT
    ROUND(AVG(CustomerSales),2) AS Average_Sales_Per_Customer
FROM
(
    SELECT
        customer_id,
        SUM(sales) AS CustomerSales
    FROM retail_sales
    GROUP BY customer_id
) AS customer_summary;



-- ===================================
-- Query 15 : Rank States by Sales
-- ===================================

SELECT
    state_province,
    ROUND(SUM(sales),2) AS Total_Sales,
    RANK() OVER (ORDER BY SUM(sales) DESC) AS Sales_Rank
FROM retail_sales
GROUP BY state_province;



-- ===================================
-- Query 16 : Running Total
-- ===================================

SELECT
    order_year,
    order_month,
    ROUND(SUM(sales),2) AS Monthly_Sales,
    ROUND(
        SUM(SUM(sales)) OVER(
            ORDER BY order_year,
            FIELD(order_month,
            'January','February','March','April','May','June',
            'July','August','September','October','November','December')
        ),2
    ) AS Running_Total
FROM retail_sales
GROUP BY
    order_year,
    order_month;
    
    
    
    -- ===================================
-- Query 17 : Top Customer in Each Segment
-- ===================================

WITH CustomerSales AS
(
SELECT
    segment,
    customer_name,
    SUM(sales) AS TotalSales
FROM retail_sales
GROUP BY
    segment,
    customer_name
)

SELECT *
FROM
(
SELECT *,
RANK() OVER(
PARTITION BY segment
ORDER BY TotalSales DESC
) AS CustomerRank
FROM CustomerSales
) ranked
WHERE CustomerRank = 1;




-- ===================================
-- Query 18 : Top Products by Profit
-- ===================================

SELECT
    product_name,
    ROUND(SUM(profit),2) AS Total_Profit,
    DENSE_RANK() OVER(
        ORDER BY SUM(profit) DESC
    ) AS Profit_Rank
FROM retail_sales
GROUP BY product_name
LIMIT 5;