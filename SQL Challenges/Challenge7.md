

## 📈 A. High Level Sales Analysis

**1. What was the total quantity sold for all products?**

```sql
SELECT 
  product.product_name, 
  SUM(sales.qty) AS total_quantity
FROM balanced_tree.sales
INNER JOIN balanced_tree.product_details AS product
	ON sales.prod_id = product.product_id
GROUP BY product.product_name;
```

**Answer:**
| total_quantity_sold 	|
|---------------------	|
| 45216               	|

***

**2. What is the total generated revenue for all products before discounts?**

```sql
SELECT SUM(qty * price) AS total_revenue_before_discounts
FROM sales;
```

**Answer:**

| total_revenue_before_discounts 	|
|---------------------	|
| 1289453               	|

***

**3. What was the total discount amount for all products?**

```sql
SELECT SUM(discount * qty) AS total_discount_amount
FROM sales;
```

**Answer:**

| total_discount_amount 	|
|---------------------	|
| 546431               	|

***

## 🧾 B. Transaction Analysis

**1. How many unique transactions were there?**

```sql
SELECT COUNT(DISTINCT txn_id) AS unique_transactions
FROM sales;
```

**Answer:**

|unique_transactions|
|:----|
|2500|

***

**2. What is the average unique products purchased in each transaction?**

```sql
SELECT AVG(unique_products) AS avg_unique_products_per_txn
FROM (
  SELECT txn_id, COUNT(DISTINCT prod_id) AS unique_products
  FROM sales
  GROUP BY txn_id
) AS subquery;
```

**Answer:**

|avg_unique_products_per_txn|
|:----|
|6|

***

**3. What are the 25th, 50th and 75th percentile values for the revenue per transaction?**

```sql
SELECT 
  percentile_cont(0.25) WITHIN GROUP (ORDER BY revenue) AS percentile_25th,
  percentile_cont(0.50) WITHIN GROUP (ORDER BY revenue) AS percentile_50th,
  percentile_cont(0.75) WITHIN GROUP (ORDER BY revenue) AS percentile_75th
FROM (
  SELECT txn_id, SUM(qty * price) AS revenue
  FROM sales
  GROUP BY txn_id
) AS subquery;
```

**Answer:**

|percentile_25th|percentile_50th|percentile_75th|
|:----|:----|:----|
|375.75|509.5|647|

***

**4. What is the average discount value per transaction?**

```sql
SELECT AVG(discount_amount) AS avg_discount_per_txn
FROM (
  SELECT txn_id, SUM(discount * qty) AS discount_amount
  FROM sales
  GROUP BY txn_id
) AS subquery;
```

**Answer:**

|avg_discount_per_txn|
|:----|
|218|

**5. What is the percentage split of all transactions for members vs non-members?**

```sql
SELECT 
  SUM(CASE WHEN member THEN 1 ELSE 0 END)::float / COUNT(*) * 100 AS member_percentage,
  SUM(CASE WHEN NOT member THEN 1 ELSE 0 END)::float / COUNT(*) * 100 AS non_member_percentage
FROM sales;
```

**Answer:**

| member_percentage 	| non_member_percentage 	|
|-------------------	|-----------------------	|
| 60. 	| 40    	|

***

**6. What is the average revenue for member transactions and non-member transactions?**

```sql
SELECT 
  AVG(CASE WHEN member THEN revenue ELSE NULL END) AS avg_member_revenue,
  AVG(CASE WHEN NOT member THEN revenue ELSE NULL END) AS avg_non_member_revenue
FROM (
  SELECT txn_id, member, SUM(qty * price) AS revenue
  FROM sales
  GROUP BY txn_id, member
) AS subquery;
```

**Answer:**

| avg_member_revenue   	| avg_non_member_revenue 	|
|----------------------	|------------------------	|
| 516.3 	| 515   	|

***

## 👚 C. Product Analysis

**1. What are the top 3 products by total revenue before discount?**

```sql
SELECT prod_id, SUM(qty * price) AS total_revenue
FROM sales
GROUP BY prod_id
ORDER BY total_revenue DESC
LIMIT 3;
```

**Answer:**

| prod_id 	| total_revenue 	|
|---------	|---------------	|
| 2a2353  	| 217683        	|
| 9ec847  	| 209304        	|
| 5d267b  	| 152000        	|

***

**2. What is the total quantity, revenue and discount for each segment?**

```sql
SELECT ph.level_text AS segment, SUM(s.qty) AS total_qty, SUM(s.qty * s.price) AS total_revenue, SUM(s.qty * s.discount) AS total_discount
FROM sales s
JOIN product_details pd ON s.prod_id = pd.product_id
JOIN product_hierarchy ph ON pd.segment_id = ph.id
GROUP BY segment;
```

**Answer:**

| segment 	| total_qty 	| total_revenue 	| total_discount 	|
|---------	|-----------	|---------------	|----------------	|
| Shirt   	| 11265     	| 406143        	| 136971         	|
| Jeans   	| 11349     	| 208350        	| 137909         	|
| Jacket  	| 11385     	| 366983        	| 137044         	|
| Socks   	| 11217     	| 307977        	| 134507         	|

***

**3. What is the top selling product for each segment?**

```sql
SELECT segment, product_name, total_qty
FROM (
  SELECT ph.level_text AS segment, pd.product_name, SUM(s.qty) AS total_qty
  FROM sales s
  JOIN product_details pd ON s.prod_id = pd.product_id
  JOIN product_hierarchy ph ON pd.segment_id = ph.id
  GROUP BY ph.level_text, pd.product_name
) AS subquery
ORDER BY segment, total_qty DESC;
```

**Answer:**

| segment 	| product_name                     	| total_qty 	|
|---------	|----------------------------------	|-----------	|
| Jacket  	| Grey Fashion Jacket - Womens     	| 3876      	|
| Jacket  	| Indigo Rain Jacket - Womens      	| 3757      	|
| Jacket  	| Khaki Suit Jacket - Womens       	| 3752      	|
| Jeans   	| Navy Oversized Jeans - Womens    	| 3856      	|
| Jeans   	| Black Straight Jeans - Womens    	| 3786      	|
| Jeans   	| Cream Relaxed Jeans - Womens     	| 3707      	|
| Shirt   	| Blue Polo Shirt - Mens           	| 3819      	|
| Shirt   	| White Tee Shirt - Mens           	| 3800      	|
| Shirt   	| Teal Button Up Shirt - Mens      	| 3646      	|
| Socks   	| Navy Solid Socks - Mens          	| 3792      	|
| Socks   	| Pink Fluro Polkadot Socks - Mens 	| 3770      	|
| Socks   	| White Striped Socks - Mens       	| 3655      	|

***

**4. What is the total quantity, revenue and discount for each category?**

```sql
SELECT ph.level_text AS category, SUM(s.qty) AS total_qty, SUM(s.qty * s.price) AS total_revenue, SUM(s.qty * s.discount) AS total_discount
FROM sales s
JOIN product_details pd ON s.prod_id = pd.product_id
JOIN product_hierarchy ph ON pd.category_id = ph.id
GROUP BY category;
```

**Answer:**

| category 	| total_qty 	| total_revenue 	| total_discount 	|
|----------	|-----------	|---------------	|----------------	|
| Mens     	| 22482     	| 714120        	| 271478         	|
| Womens   	| 22734     	| 575333        	| 274953         	|

***

**5. What is the top selling product for each category?**

```sql
SELECT segment, product_name, total_qty
FROM (
  SELECT ph.level_text AS segment, pd.product_name, SUM(s.qty) AS total_qty,
         ROW_NUMBER() OVER (PARTITION BY ph.level_text ORDER BY SUM(s.qty) DESC) AS rn
  FROM sales s
  JOIN product_details pd ON s.prod_id = pd.product_id
  JOIN product_hierarchy ph ON pd.segment_id = ph.id
  GROUP BY ph.level_text, pd.product_name
) subquery
WHERE rn = 1;
```

**Answer:**

| segment 	| product_name                  	| total_qty 	|
|---------	|-------------------------------	|-----------	|
| Jacket  	| Grey Fashion Jacket - Womens  	| 3876      	|
| Jeans   	| Navy Oversized Jeans - Womens 	| 3856      	|
| Shirt   	| Blue Polo Shirt - Mens        	| 3819      	|
| Socks   	| Navy Solid Socks - Mens       	| 3792      	|

***

**6. What is the percentage split of revenue by product for each segment?**

```sql
SELECT ph.level_text AS segment, pd.product_name, 
       (SUM(s.qty * s.price)::float / SUM(SUM(s.qty * s.price)) OVER (PARTITION BY ph.level_text)) * 100 AS revenue_percentage_split
FROM sales s
JOIN product_details pd ON s.prod_id = pd.product_id
JOIN product_hierarchy ph ON pd.segment_id = ph.id
GROUP BY ph.level_text, pd.product_name;
```

**Answer:**

| segment 	| product_name                     	| revenue_percentage_split 	|
|---------	|----------------------------------	|--------------------------	|
| Jacket  	| Grey Fashion Jacket - Womens     	| 57.033704558521784       	|
| Jacket  	| Indigo Rain Jacket - Womens      	| 19.451309733693385       	|
| Jacket  	| Khaki Suit Jacket - Womens       	| 23.51498570778483        	|
| Jeans   	| Black Straight Jeans - Womens    	| 58.14830813534917        	|
| Jeans   	| Cream Relaxed Jeans - Womens     	| 17.792176625869928       	|
| Jeans   	| Navy Oversized Jeans - Womens    	| 24.0595152387809         	|
| Shirt   	| Blue Polo Shirt - Mens           	| 53.597624482017416       	|
| Shirt   	| Teal Button Up Shirt - Mens      	| 8.977133669668072        	|
| Shirt   	| White Tee Shirt - Mens           	| 37.42524184831451        	|
| Socks   	| Navy Solid Socks - Mens          	| 44.325387934813314       	|
| Socks   	| Pink Fluro Polkadot Socks - Mens 	| 35.49940417628589        	|
| Socks   	| White Striped Socks - Mens       	| 20.175207888900797       	|

***

**7. What is the percentage split of revenue by segment for each category?**

```sql
SELECT pd.category_name AS category, pd.segment_name, 
       (SUM(s.qty * s.price)::float / SUM(SUM(s.qty * s.price)) OVER (PARTITION BY pd.category_name)) * 100 AS revenue_percentage_split_by_segment
FROM sales s
JOIN product_details pd ON s.prod_id = pd.product_id
GROUP BY pd.category_name, pd.segment_name;
```

**Answer:**

| category 	| segment_name 	| revenue_percentage_split_by_segment 	|
|----------	|--------------	|-------------------------------------	|
| Mens     	| Socks        	| 43.126785414216094                  	|
| Mens     	| Shirt        	| 56.873214585783906                  	|
| Womens   	| Jeans        	| 36.21381008911361                   	|
| Womens   	| Jacket       	| 63.78618991088639                   	|

***

**8. What is the percentage split of total revenue by category?**

```sql
SELECT pd.category_name AS category, 
       (SUM(s.qty * s.price)::float / SUM(SUM(s.qty * s.price)) OVER ()) * 100 AS revenue_percentage_split_by_category
FROM sales s
JOIN product_details pd ON s.prod_id = pd.product_id
GROUP BY pd.category_name;
```

**Answer:**

| category 	| revenue_percentage_split_by_category 	|
|----------	|--------------------------------------	|
| Mens     	| 55.381623060320926                   	|
| Womens   	| 44.618376939679074                   	|

***

**9. What is the total transaction “penetration” for each product? (hint: penetration = number of transactions where at least 1 quantity of a product was purchased divided by total number of transactions)**

```sql
SELECT pd.product_name, 
       COUNT(DISTINCT s.txn_id)::float / (SELECT COUNT(DISTINCT txn_id) FROM sales) AS penetration
FROM sales s
JOIN product_details pd ON s.prod_id = pd.product_id
GROUP BY pd.product_name;
```

**Answer:**

| product_name                     	| penetration 	|
|----------------------------------	|-------------	|
| Black Straight Jeans - Womens    	| 0.4984      	|
| Blue Polo Shirt - Mens           	| 0.5072      	|
| Cream Relaxed Jeans - Womens     	| 0.4972      	|
| Grey Fashion Jacket - Womens     	| 0.51        	|
| Indigo Rain Jacket - Womens      	| 0.5         	|
| Khaki Suit Jacket - Womens       	| 0.4988      	|
| Navy Oversized Jeans - Womens    	| 0.5096      	|
| Navy Solid Socks - Mens          	| 0.5124      	|
| Pink Fluro Polkadot Socks - Mens 	| 0.5032      	|
| Teal Button Up Shirt - Mens      	| 0.4968      	|
| White Striped Socks - Mens       	| 0.4972      	|
| White Tee Shirt - Mens           	| 0.5072      	|

***

**10. What is the most common combination of at least 1 quantity of any 3 products in a 1 single transaction?**

```sql
SELECT s1.prod_id AS product1, s2.prod_id AS product2, s3.prod_id AS product3, COUNT(*) AS combination_count
FROM sales s1
JOIN sales s2 ON s1.txn_id = s2.txn_id AND s1.prod_id < s2.prod_id
JOIN sales s3 ON s1.txn_id = s3.txn_id AND s2.prod_id < s3.prod_id
GROUP BY s1.prod_id, s2.prod_id, s3.prod_id
ORDER BY combination_count DESC
LIMIT 1;
```

**Answer:**

| product1 	| product2 	| product3 	| combination_count 	|
|----------	|----------	|----------	|-------------------	|
| 5d267b   	| 9ec847   	| c8d436   	| 352               	|

***


