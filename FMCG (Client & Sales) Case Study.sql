# A)	Using dim_sales_item:


# 1.	Write a query to find the first captured date for each barcode in the table.

SELECT barcode, max (captured_date)
FROM EA.dbo.[dim_sales_item$]
GROUP BY barcode

# 2.	Write a query to find a list of product names which contain the string ‘190’ 

SELECT sales_item_name
FROM EA.dbo.[dim_sales_item$]
WHERE sales_item_name LIKE '%190%'

# 3.	For each barcode in each store, write a query to find the latest sales item name captured.

SELECT barcode
FROM EA.dbo.[dim_sales_item$]
WHERE barcode IN
	(SELECT store_id, max (captured_date) as max_captured_date
	FROM EA.dbo.[dim_sales_item$]
	GROUP BY store_id)

SELECT store_id, barcode, captured_date
FROM EA.dbo.[dim_sales_item$]


# B)	Using dim_sales_item & fct_sales:

select *
from EA.dbo.[fct_sales$]

# 1.	Write a query to find the total number of units sold & total sales for each barcode in the last 3 days.  (note: if possible, please use datediff in your where condition)

SELECT  t1.barcode as Barcode, SUM(t2.Sales) as Total_Sales 
FROM EA.dbo.[fct_sales$] AS t2
INNER JOIN  EA.dbo.[dim_sales_item$] AS t1
ON t1.sales_item_id = t2.sales_item_id
WHERE DATEDIFF(day, NOW(), sales_date) = 3
GROUP BY Barcode

# 2.	Write a query to fetch all the barcode not present in the fct_sales table

SELECT barcode AS t1
FROM EA.dbo.[dim_sales_item$] AS t1
WHERE t1.sales_item_id NOT IN 
(SELECT t2.sales_item_id
FROM EA.dbo.[fct_sales$] AS t2)

# C)	Using fct_transactions:

select *
from EA.dbo.[fct_transactions$]


# 1.	Write a query to find the average sales turnover gross for each product on a daily basis

SELECT product_id, AVG (sales_turnover_gross) as Average_Sales_Turnover_Gross
FROM EA.dbo.[fct_transactions$]
GROUP BY product_id

# 2.	Write a query to find the product with the 3rd lowest price


SELECT product_id, MAX (sales_price)
FROM 
(SELECT product_id, sales_price
FROM EA.dbo.[fct_transactions$]
ORDER BY sales_price
LIMIT 3);

# 3.	Write a query to find the product with the 2rd highest price 

SELECT product_id, MIN (sales_price)
FROM 
(SELECT product_id, sales_price
FROM EA.dbo.[fct_transactions$]
ORDER BY sales_price DESC
LIMIT 2);

# D)	Using table1 and table2:

select *
from EA.dbo.[table1$]

select *
from EA.dbo.[table2$]

# 1.	Write a query to find the matching records between table 1 and table 2

SELECT t1.Id AS id1, t2.Id AS id2, t1.name AS name1, t2.name AS name2
FROM EA.dbo.[table1$] AS t1
INNER JOIN EA.dbo.[table2$] AS t2
ON t1.Id = t2.Id

# 2.	For all the records in table 2, find only the non-matching records against table 1

SELECT t2.Id 
FROM EA.dbo.[table2$] AS t2
EXCEPT 
SELECT t1.Id 
FROM EA.dbo.[table1$] AS t1









