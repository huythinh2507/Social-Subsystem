## 👩🏻‍💻 A. Digital Analysis

**1. How many users are there?**

````sql
SELECT 
  COUNT(DISTINCT user_id) AS user_count
FROM users;
````
| user_count 	|
|------------	|
| 500        	|

**2. How many cookies does each user have on average?**

````sql
SELECT AVG(cookie_count) AS average_cookies_per_user
FROM (SELECT COUNT(cookie_id) AS cookie_count FROM users GROUP BY user_id) AS subquery;
````

| average_cookies_per_user 	|
|------------	|
| 3.564        	|

**3. What is the unique number of visits by all users per month?**

````sql
SELECT DATE_TRUNC('month', start_date) AS month, COUNT(DISTINCT cookie_id) AS unique_visits
FROM users
GROUP BY month;
````

| month                    	| unique_visits 	|
|--------------------------	|---------------	|
| 2020-01-01T00:00:00.000Z 	| 438           	|
| 2020-02-01T00:00:00.000Z 	| 744           	|
| 2020-03-01T00:00:00.000Z 	| 458           	|
| 2020-04-01T00:00:00.000Z 	| 124           	|
| 2020-05-01T00:00:00.000Z 	| 18            	|

**4. What is the number of events for each event type?**

````sql
SELECT e.event_type, COUNT(*) AS event_count
FROM events e
JOIN event_identifier ei ON e.event_type = ei.event_type
GROUP BY e.event_type;
````

| event_type 	| event_count 	|
|------------	|-------------	|
| 1          	| 20928       	|
| 2          	| 8451        	|
| 3          	| 1777        	|
| 4          	| 876         	|
| 5          	| 702         	|

**5. What is the percentage of visits which have a purchase event?**

````sql
SELECT (COUNT(DISTINCT case when event_type = 3 then cookie_id end) / COUNT(DISTINCT cookie_id)::float) * 100 AS purchase_percentage
FROM events;
````

| purchase_percentage                    	| 
|--------------------------	|
| 75.86 	| 

**6. What is the percentage of visits which view the checkout page but do not have a purchase event?**

````sql
SELECT (COUNT(DISTINCT case when page_id = 12 AND event_type != 3 then cookie_id end) / COUNT(DISTINCT cookie_id)::float) * 100 AS checkout_no_purchase_percentage
FROM events;
````

| checkout_no_purchase_percentage                    	| 
|--------------------------	|
| 85.57 	| 

**7. What are the top 3 pages by number of views?**

````sql
SELECT page_id, COUNT(*) AS view_count
FROM events
WHERE event_type = 1 -- assuming event_type 1 is 'Page View'
GROUP BY page_id
ORDER BY view_count DESC
LIMIT 3;
````
| page_id 	| view_count 	|
|---------	|------------	|
| 2       	| 3174       	|
| 12      	| 2103       	|
| 1       	| 1782       	|

**8. What is the number of views and cart adds for each product category?**

````sql
SELECT ph.product_category, 
       SUM(CASE WHEN e.event_type = 1 THEN 1 ELSE 0 END) AS views,
       SUM(CASE WHEN e.event_type = 2 THEN 1 ELSE 0 END) AS cart_adds
FROM events e
JOIN page_hierarchy ph ON e.page_id = ph.page_id
GROUP BY ph.product_category;
````

| product_category 	| views 	| cart_adds 	|
|------------------	|-------	|-----------	|
| null             	| 7059  	| 0         	|
| Luxury           	| 3032  	| 1870      	|
| Shellfish        	| 6204  	| 3792      	|
| Fish             	| 4633  	| 2789      	|

**9. What are the top 3 products by purchases?**

````sql
SELECT ph.product_category, 
       SUM(CASE WHEN e.event_type = 1 THEN 1 ELSE 0 END) AS views,
       SUM(CASE WHEN e.event_type = 2 THEN 1 ELSE 0 END) AS cart_adds
FROM events e
JOIN page_hierarchy ph ON e.page_id = ph.page_id
GROUP BY ph.product_category;
````

| product_id 	| purchase_count 	|
|------------------	|-------	|
| null             	| 1777  	| 

***

## 👩🏻‍💻 B. Product Funnel Analysis

Using a single SQL query - create a new output table which has the following details:

1. How many times was each product viewed?
2. How many times was each product added to cart?
3. How many times was each product added to a cart but not purchased (abandoned)?
4. How many times was each product purchased?

```sql
WITH product_page_events AS (
  SELECT 
    e.visit_id,
    ph.product_id,
    ph.page_name AS product_name,
    ph.product_category,
    SUM(CASE WHEN e.event_type = 1 THEN 1 ELSE 0 END) AS page_view,
    SUM(CASE WHEN e.event_type = 2 THEN 1 ELSE 0 END) AS cart_add
  FROM events AS e
  JOIN page_hierarchy AS ph ON e.page_id = ph.page_id
  WHERE product_id IS NOT NULL
  GROUP BY e.visit_id, ph.product_id, ph.page_name, ph.product_category
),
purchase_events AS (
  SELECT 
    DISTINCT visit_id
  FROM events
  WHERE event_type = 3
),
combined_table AS (
  SELECT 
    ppe.visit_id, 
    ppe.product_id, 
    ppe.product_name, 
    ppe.product_category, 
    ppe.page_view, 
    ppe.cart_add,
    CASE WHEN pe.visit_id IS NOT NULL THEN 1 ELSE 0 END AS purchase
  FROM product_page_events AS ppe
  LEFT JOIN purchase_events AS pe ON ppe.visit_id = pe.visit_id
),
product_info AS (
  SELECT 
    product_id,
    product_name, 
    product_category, 
    SUM(page_view) AS views,
    SUM(cart_add) AS cart_adds, 
    SUM(CASE WHEN cart_add > 0 AND purchase = 0 THEN cart_add ELSE 0 END) AS abandoned,
    SUM(purchase) AS purchases
  FROM combined_table
  GROUP BY product_id, product_name, product_category
)
SELECT *
FROM product_info
ORDER BY product_id;

```
| product_id 	| product_name   	| product_category 	| views 	| cart_adds 	| abandoned 	| purchases 	|
|------------	|----------------	|------------------	|-------	|-----------	|-----------	|-----------	|
| 1          	| Salmon         	| Fish             	| 1559  	| 938       	| 227       	| 1094      	|
| 2          	| Kingfish       	| Fish             	| 1559  	| 920       	| 213       	| 1106      	|
| 3          	| Tuna           	| Fish             	| 1515  	| 931       	| 234       	| 1058      	|
| 4          	| Russian Caviar 	| Luxury           	| 1563  	| 946       	| 249       	| 1088      	|
| 5          	| Black Truffle  	| Luxury           	| 1469  	| 924       	| 217       	| 1045      	|
| 6          	| Abalone        	| Shellfish        	| 1525  	| 932       	| 233       	| 1085      	|
| 7          	| Lobster        	| Shellfish        	| 1547  	| 968       	| 214       	| 1113      	|
| 8          	| Crab           	| Shellfish        	| 1564  	| 949       	| 230       	| 1108      	|
| 9          	| Oyster         	| Shellfish        	| 1568  	| 943       	| 217       	| 1136      	|
***

