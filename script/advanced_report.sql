---Analyse Sales Performance Over Time 
SELECT 
	YEAR(order_date) AS order_date, 
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_customers 
FROM dbo.[gold.fact_sales]
WHERE YEAR(order_date) IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date)


--------------------------------------------------------------------


SELECT 
	MONTH(order_date) AS order_date, 
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_customers 
FROM dbo.[gold.fact_sales]
WHERE MONTH(order_date) IS NOT NULL
GROUP BY MONTH(order_date)
ORDER BY MONTH(order_date)



---------------------------------------------------------------


WITH cte_fact_sale AS
(
SELECT 
	DATETRUNC(MONTH,order_date) AS order_date, 
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_customers 
FROM dbo.[gold.fact_sales]
WHERE DATETRUNC(MONTH,order_date) IS NOT NULL
GROUP BY DATETRUNC(MONTH,order_date)
)
SELECT 
order_date,
total_customers,
total_sales,
LAG(total_sales) OVER(ORDER BY order_date) AS prev_month_sales
FROM cte_fact_sale;



---------------------------------------------------------------------
WITH cte_fact_sales AS 
(
SELECT
DATETRUNC(YEAR,order_date) AS year_order,
SUM(sales_amount) AS total_amount,
AVG(sales_amount) AS avg_amount
FROM dbo.[gold.fact_sales]
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(YEAR,order_date)
)
SELECT 
year_order,
total_amount,
SUM(total_amount) OVER(ORDER BY year_order) AS running_sum,
AVG(avg_amount) OVER(ORDER BY year_order) AS moving_avg
FROM cte_fact_sales


SELECT
order_date,
total_amount,
SUM(total_amount) OVER(ORDER BY order_date) AS moving_sum,
AVG(avg_amount) OVER(ORDER BY order_date) AS moving_avg

FROM(
SELECT
DATETRUNC(YEAR,order_date) AS order_date,
SUM(sales_amount) AS total_amount,
AVG(sales_amount) AS avg_amount
FROM dbo.[gold.fact_sales]
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(YEAR,order_date)
)t

SELECT * FROM dbo.[gold.dim_customers];
SELECT * FROM dbo.[gold.dim_products];
SELECT * FROM dbo.[gold.fact_sales];
