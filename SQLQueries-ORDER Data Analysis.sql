--find top 10 highest revenue generating products
use master

select top 10 PRODUCT_ID, SUM(SALE_PRICE) as SALES
FROM df_orders
GROUP BY product_id
ORDER BY SALES DESC


--find top 10 highest revenue generating products
WITH cte as(
select region, PRODUCT_ID, SUM(SALE_PRICE) as SALES
FROM df_orders
GROUP BY region, product_id)
SELECT * FROM (
SELECT *,
ROW_NUMBER() OVER(PARTITION BY region ORDER BY sales DESC) as RNK
FROM CTE) A
WHERE RNK <=5

-- find month over month growth comparison fro year 2022 and 2023 for January
WITH CTE AS(
Select year(order_date) as orderyear, month(order_date) ordermonth,
SUM(sale_price) as sales
FROM df_orders
GROUP BY year(order_date) , month(order_date)
--ORDER BY orderyear, ordermonth
)
SELECT ordermonth,
SUM(case when orderyear = 2022 then sales else 0 end) as sales_2022,
SUM(case when orderyear = 2023 then sales else 0 end) as sales_2023
FROM
CTE
GROUP BY ordermonth
ORDER BY ordermonth

--for eeach category which month has the highest sale
WITH CTE AS(
SELECT category, format(order_date, 'yyyyMM') as order_year_month, 
SUM(sale_price) as SALES
FROM df_orders
GROUP BY category, format(order_date, 'yyyyMM') 
--ORDER BY category, format(order_date, 'yyyyMM') 
)
SELECT * FROM(
SELECT *, 
ROW_NUMBER() OVER(PARTITION BY category ORDER BY SALES DESC) as RN
FROM CTE) Y
WHERE RN=1

