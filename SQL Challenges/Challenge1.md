## Question and Solution
**1. What is the total amount each customer spent at the restaurant?**

````sql
SELECT customer_id, SUM(price) as total_spent
FROM sales
JOIN menu ON sales.product_id = menu.product_id
GROUP BY customer_id
ORDER BY sales.customer_id ASC;
````

#### Steps:
- SELECT: This is the command used to select data from a database. The data returned is stored in a result table, called the result-set. In this case, we’re selecting customer_id and the sum of price.
- FROM sales: This specifies the table from which we want to retrieve data. Here, we’re retrieving data from the sales table.
- JOIN menu ON sales.product_id = menu.product_id: This is a JOIN clause that combines rows from two or more tables based on a related column between them. Here, we’re joining the sales table with the menu table where the product_id matches in both.
- GROUP BY customer_id: This groups the result-set by one or more columns. Here, we’re grouping the resulting data by customer_id.
- SUM(price) as total_spent: This is an aggregate function that returns the summed value of the specified column. Here, we’re summing up the price for each customer_id. The as total_spent part renames the column in the output.
- ORDER BY sales.customer_id ASC: This is used to sort the data in ascending order by customer_id from the sales table.

#### Answer:
| customer_id | total_sales |
| ----------- | ----------- |
| A           | 76          |
| B           | 74          |
| C           | 36          |

- Customer A spent $76.
- Customer B spent $74.
- Customer C spent $36.

***

**2. How many days has each customer visited the restaurant?**

````sql
SELECT customer_id, COUNT(DISTINCT order_date) as days_visited
FROM sales
GROUP BY customer_id;
````

#### Steps:
- SELECT: This is the command used to select data from a database. The data returned is stored in a result table, called the result-set. In this case, we’re selecting customer_id and the count of distinct order_date.
- FROM sales: This specifies the table from which we want to retrieve data. Here, we’re retrieving data from the sales table.
- COUNT(DISTINCT order_date) as days_visited: This is an aggregate function that returns the count of distinct order_date for each customer_id. The as days_visited part renames the column in the output.
- GROUP BY customer_id: This groups the result-set by one or more columns. Here, we’re grouping the resulting data by customer_id.

#### Answer:
| customer_id | visit_count |
| ----------- | ----------- |
| A           | 4          |
| B           | 6          |
| C           | 2          |

- Customer A visited 4 times.
- Customer B visited 6 times.
- Customer C visited 2 times.

***

**3. What was the first item from the menu purchased by each customer?**

````sql
SELECT customer_id, product_name
FROM (
  SELECT sales.customer_id, menu.product_name, sales.order_date,
  ROW_NUMBER() OVER(PARTITION BY sales.customer_id ORDER BY sales.order_date) as rn
  FROM sales
  JOIN menu ON sales.product_id = menu.product_id
) tmp
WHERE rn = 1;
````

#### Steps:
- The subquery selects customer_id, product_name, and order_date from the joined sales and menu tables.
- It assigns a unique row number to each row within each customer_id, ordered by order_date in ascending order. This is done using the ROW_NUMBER() OVER(PARTITION BY sales.customer_id ORDER BY sales.order_date) function.
- The outer query then selects the customer_id and product_name where the row number is 1, which corresponds to the first item purchased by each customer.

#### Answer:
| customer_id | product_name | 
| ----------- | ----------- |
| A           | curry        | 
| B           | curry        | 
| C           | ramen        |

- Customer A's first order is curry.
- Customer B's first order is curry.
- Customer C's first order is ramen.

***

**4. What is the most purchased item on the menu and how many times was it purchased by all customers?**

````sql
SELECT product_name, COUNT(*) as count
FROM sales
JOIN menu ON sales.product_id = menu.product_id
GROUP BY product_name
ORDER BY count DESC
LIMIT 1;
````

#### Steps:
- The query selects product_name from the joined sales and menu tables.
- It counts the number of times each product was purchased using the COUNT(*) function and groups the results by product_name.
- It then orders the results by the count in descending order and limits the result to 1, giving the most purchased item on the menu.

#### Answer:
| product_name | count | 
| ----------- | ----------- |
| ramen       | 8 |

***

**5. Which item was the most popular for each customer?**

````sql
SELECT customer_id, product_name, COUNT(*) as count
FROM sales
JOIN menu ON sales.product_id = menu.product_id
GROUP BY customer_id, product_name
ORDER BY customer_id, count DESC;
````
#### Steps:
- The query selects customer_id, product_name from the joined sales and menu tables.
- It counts the number of times each customer purchased each product using the COUNT(*) function and groups the results by customer_id and product_name.
- It then orders the results by customer_id and the count in descending order, giving the most popular item for each customer.

#### Answer:
| customer_id | product_name | order_count |
| ----------- | ---------- |------------  |
| A           | ramen        |  3   |
| A           | curry        |  2   |
| A           | sushi        |  1   |
| B           | ramen        |  2   |
| B           | curry        |  2   |
| B           | sushi        |  2   |
| C           | ramen        |  3   |

- Customer A and C's favourite item is ramen.
- Customer B likes all items on the menu. 

***

**6. Which item was purchased first by the customer after they became a member?**

```sql
SELECT m.customer_id, menu.product_name
FROM members m
JOIN (
  SELECT customer_id, MIN(order_date) as min_order_date
  FROM sales
  WHERE order_date >= (SELECT join_date FROM members WHERE customer_id = sales.customer_id)
  GROUP BY customer_id
) s ON m.customer_id = s.customer_id
JOIN sales s2 ON m.customer_id = s2.customer_id AND s.min_order_date = s2.order_date
JOIN menu ON s2.product_id = menu.product_id
  ORDER BY customer_id ASC;
```

#### Steps:
- The subquery selects the customer_id and the minimum order_date (i.e., the first purchase date) from the sales table for each customer after they became a member.
- The outer query then joins the members, sales, and menu tables, and selects the customer_id and product_name where the order_date matches the first purchase date after the customer became a member.

#### Answer:
| customer_id | product_name |
| ----------- | ---------- |
| A           | curry        |
| B           | sushi        |

- Customer A's first order as a member is curry.
- Customer B's first order as a member is sushi.

***

**7. Which item was purchased just before the customer became a member?**

````sql
SELECT customer_id, product_name
FROM (
  SELECT m.customer_id, menu.product_name, 
  ROW_NUMBER() OVER(PARTITION BY m.customer_id ORDER BY s.order_date DESC) as rn
  FROM members m
  JOIN sales s ON m.customer_id = s.customer_id
  JOIN menu ON s.product_id = menu.product_id
  WHERE s.order_date < m.join_date
) tmp
WHERE rn = 1;
````

#### Steps:
- The subquery selects customer_id, product_name, and order_date from the joined members, sales, and menu tables for purchases made before the customer became a member.
- It assigns a unique row number to each row within each customer_id, ordered by order_date in descending order. This is done using the ROW_NUMBER() OVER(PARTITION BY m.customer_id ORDER BY s.order_date DESC) function.
- The outer query then selects the customer_id and product_name where the row number is 1, which corresponds to the last item purchased by each customer before they became a member.

#### Answer:
| customer_id | product_name |
| ----------- | ---------- |
| A           | sushi        |
| B           | sushi        |

- Both customers' last order before becoming members are sushi.

***

**8. What is the total items and amount spent for each member before they became a member?**

```sql
SELECT m.customer_id, COUNT(*) as total_items, SUM(price) as total_spent
FROM members m
JOIN sales s ON m.customer_id = s.customer_id
JOIN menu ON s.product_id = menu.product_id
WHERE s.order_date < m.join_date
GROUP BY m.customer_id
ORDER BY m.customer_id ASC;
```

#### Steps:
- The query selects customer_id from the joined members, sales, and menu tables for purchases made before the customer became a member.
- It counts the number of items purchased and calculates the total amount spent using the COUNT(*) and SUM(price) functions, respectively.
- It groups the results by customer_id, giving the total items and amount spent for each member before they became a member.

#### Answer:
| customer_id | total_items | total_sales |
| ----------- | ---------- |----------  |
| A           | 2 |  25       |
| B           | 3 |  40       |

Before becoming members,
- Customer A spent $25 on 2 items.
- Customer B spent $40 on 3 items.

***

**9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier — how many points would each customer have?**

```sql
SELECT customer_id, SUM(points) as total_points
FROM (
  SELECT sales.customer_id, 
  CASE 
    WHEN menu.product_name = 'sushi' THEN menu.price * 20
    ELSE menu.price * 10
  END as points
  FROM sales
  JOIN menu ON sales.product_id = menu.product_id
) tmp
GROUP BY customer_id
ORDER BY customer_id ASC;
```

#### Steps:
- The subquery selects customer_id from the joined sales and menu tables, and calculates the points earned from each purchase. If the product is ‘sushi’, the points are 20 times the price; otherwise, the points are 10 times the price.
- The outer query then sums up the points for each customer_id, giving the total points for each customer.

#### Answer:
| customer_id | total_points | 
| ----------- | ---------- |
| A           | 860 |
| B           | 940 |
| C           | 360 |

- Total points for Customer A is $860.
- Total points for Customer B is $940.
- Total points for Customer C is $360.

***

**10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi — how many points do customer A and B have at the end of January?**

```sql
SELECT sales.customer_id,
       SUM(CASE
               WHEN sales.order_date BETWEEN members.join_date AND members.join_date + 6 THEN menu.price * 20
               WHEN sales.order_date > members.join_date + 6 THEN menu.price * 10
               ELSE 0
           END) as total_points
FROM sales
JOIN menu ON sales.product_id = menu.product_id
JOIN members ON sales.customer_id = members.customer_id
WHERE sales.customer_id IN ('A', 'B') AND EXTRACT(MONTH FROM sales.order_date) = 1
GROUP BY sales.customer_id;
```

#### Steps:
- The query selects customer_id from the joined sales, menu, and members tables, and calculates the points earned from each purchase. If the purchase was made in the first week after the customer joined the program, the points are 20 times the price; otherwise, the points are 10 times the price.
- It then sums up the points for customers ‘A’ and ‘B’ for purchases made in January, giving the total points for each customer at the end of January. 

#### Answer:
| customer_id | total_points | 
| ----------- | ---------- |
| A           | 1020 |
| B           | 320 |

- Total points for Customer A is 1,020.
- Total points for Customer B is 320.

***
