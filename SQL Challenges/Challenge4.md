## 🏦 A. Customer Nodes Exploration

**1. How many unique nodes are there on the Data Bank system?**

````sql
SELECT COUNT(DISTINCT node_id) AS unique_nodes
FROM customer_nodes;

````

**Answer:**

|unique_nodes|
|:----|
|5|

- There are 5 unique nodes on the Data Bank system.

***

**2. What is the number of nodes per region?**

````sql
SELECT r.region_name, COUNT(DISTINCT cn.node_id) AS nodes_per_region
FROM regions AS r
JOIN customer_nodes AS cn ON r.region_id = cn.region_id
GROUP BY r.region_name;
````

**Answer:**

|region_name|nodes_per_region|
|:----|:----|
|Africa|5|
|America|5|
|Asia|5|
|Australia|5|
|Europe|5|

***

**3. How many customers are allocated to each region?**

````sql
SELECT r.region_name, COUNT(DISTINCT cn.customer_id) AS customers_per_region
FROM regions AS r
JOIN customer_nodes AS cn ON r.region_id = cn.region_id
GROUP BY r.region_name;
````

**Answer:**

| region_name | customers_per_region |
|-------------|----------------------|
| Africa      | 102                  |
| America     | 105                  |
| Asia        | 95                   |
| Australia   | 110                  |
| Europe      | 88                   |

***

**4. How many days on average are customers reallocated to a different node?**

````sql
SELECT AVG(diff) AS avg_days_allocated
FROM (
  SELECT 
    customer_id, 
    node_id, 
    start_date, 
    end_date,
    LEAD(node_id) OVER (PARTITION BY customer_id ORDER BY start_date) AS next_node_id,
    LEAD(start_date) OVER (PARTITION BY customer_id ORDER BY start_date) AS next_start_date,
    CASE 
      WHEN node_id != LEAD(node_id) OVER (PARTITION BY customer_id ORDER BY start_date) THEN
        end_date - start_date
      ELSE NULL
    END AS diff
  FROM customer_nodes
) AS subquery
WHERE diff IS NOT NULL;

````

**Answer:**

|avg_node_reallocation_days|
|:----|
|14.63|

- On average, customers are reallocated to a different node every 15 days.

***

**5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?**

````sql
WITH reallocation_days AS (
  SELECT 
    r.region_name,
    cn.customer_id, 
    cn.node_id, 
    cn.start_date, 
    cn.end_date,
    LEAD(cn.node_id) OVER (PARTITION BY cn.customer_id ORDER BY cn.start_date) AS next_node_id,
    LEAD(cn.start_date) OVER (PARTITION BY cn.customer_id ORDER BY cn.start_date) AS next_start_date,
    CASE 
      WHEN cn.node_id != LEAD(cn.node_id) OVER (PARTITION BY cn.customer_id ORDER BY cn.start_date) THEN
        cn.end_date - cn.start_date
      ELSE NULL
    END AS days_before_reallocation
  FROM customer_nodes cn
  JOIN regions r ON cn.region_id = r.region_id
  WHERE cn.end_date IS NOT NULL
),
percentiles AS (
  SELECT 
    region_name,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY days_before_reallocation) AS median_days,
    PERCENTILE_CONT(0.8) WITHIN GROUP (ORDER BY days_before_reallocation) AS p80_days,
    PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY days_before_reallocation) AS p95_days
  FROM reallocation_days
  GROUP BY region_name
)

SELECT 
  region_name,
  median_days,
  p80_days,
  p95_days
FROM percentiles;
````
**Answer:**

| region_name | median_days | p80_days | p95_days |
|-------------|-------------|----------|----------|
| Africa      | 15          | 24       | 28       |
| America     | 15          | 23       | 28       |
| Asia        | 14          | 23       | 28       |
| Australia   | 14.5        | 23       | 28       |
| Europe      | 15          | 25       | 28       |

***

## 🏦 B. Customer Transactions

**1. What is the unique count and total amount for each transaction type?**

````sql
SELECT txn_type, COUNT(DISTINCT customer_id) AS unique_count, SUM(txn_amount) AS total_amount
FROM customer_transactions
GROUP BY txn_type;
````

**Answer:**

| txn_type   | unique_count | total_amount |
|------------|--------------|--------------|
| deposit    | 500          | 1359168      |
| purchase   | 448          | 806537       |
| withdrawal | 439          | 793003       |

***

**2. What is the average total historical deposit counts and amounts for all customers?**

````sql
SELECT AVG(deposit_count) AS avg_deposit_count, AVG(total_deposit_amount) AS avg_deposit_amount
FROM (
  SELECT customer_id, COUNT(*) AS deposit_count, SUM(txn_amount) AS total_deposit_amount
  FROM customer_transactions
  WHERE txn_type = 'deposit'
  GROUP BY customer_id
) AS deposits;
````
**Answer:**

|avg_deposit_count|avg_deposit_amount|
|:----|:----|
|5|2718.3|

- The average historical deposit count is 5 and the average historical deposit amount is $ 2718.

***

**3. For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?**

First, create a CTE called `monthly_transactions` to determine the count of deposit, purchase and withdrawal for each customer categorised by month using `CASE` statement and `SUM()`. 

In the main query, select the `mth` column and count the number of unique customers where:
- `deposit_count` is greater than 1, indicating more than one deposit (`deposit_count > 1`).
- Either `purchase_count` is greater than or equal to 1 (`purchase_count >= 1`) OR `withdrawal_count` is greater than or equal to 1 (`withdrawal_count >= 1`).

````sql
WITH monthly_transactions AS (
  SELECT 
    customer_id, 
    DATE_PART('month', txn_date) AS mth,
    SUM(CASE WHEN txn_type = 'deposit' THEN 0 ELSE 1 END) AS deposit_count,
    SUM(CASE WHEN txn_type = 'purchase' THEN 0 ELSE 1 END) AS purchase_count,
    SUM(CASE WHEN txn_type = 'withdrawal' THEN 1 ELSE 0 END) AS withdrawal_count
  FROM data_bank.customer_transactions
  GROUP BY customer_id, DATE_PART('month', txn_date)
)

SELECT
  mth,
  COUNT(DISTINCT customer_id) AS customer_count
FROM monthly_transactions
WHERE deposit_count > 1 
  AND (purchase_count >= 1 OR withdrawal_count >= 1)
GROUP BY mth
ORDER BY mth;
````

**Answer:**

|month|customer_count|
|:----|:----|
|1|170|
|2|277|
|3|292|
|4|103|

***

**4. What is the closing balance for each customer at the end of the month? Also show the change in balance each month in the same table output.**

Update Jun 2, 2023: Even after 2 years, I continue to find this question incredibly challenging. I have cleaned up the code and provided additional explanations. 

The key aspect to understanding the solution is to build up the tabele and run the CTEs cumulatively (run CTE 1 first, then run CTE 1 & 2, and so on). This approach allows for a better understanding of why specific columns were created or how the information in the tables progressed. 

```sql
-- CTE 1 - To identify transaction amount as an inflow (+) or outflow (-)
WITH monthly_balances_cte AS (
  SELECT 
    customer_id, 
    (DATE_TRUNC('month', txn_date) + INTERVAL '1 MONTH - 1 DAY') AS closing_month, 
    SUM(CASE 
      WHEN txn_type = 'withdrawal' OR txn_type = 'purchase' THEN -txn_amount
      ELSE txn_amount END) AS transaction_balance
  FROM data_bank.customer_transactions
  GROUP BY 
    customer_id, txn_date 
)

-- CTE 2 - Use GENERATE_SERIES() to generate as a series of last day of the month for each customer.
, monthend_series_cte AS (
  SELECT
    DISTINCT customer_id,
    ('2020-01-31'::DATE + GENERATE_SERIES(0,3) * INTERVAL '1 MONTH') AS ending_month
  FROM data_bank.customer_transactions
)

-- CTE 3 - Calculate total monthly change and ending balance for each month using window function SUM()
, monthly_changes_cte AS (
  SELECT 
    monthend_series_cte.customer_id, 
    monthend_series_cte.ending_month,
    SUM(monthly_balances_cte.transaction_balance) OVER (
      PARTITION BY monthend_series_cte.customer_id, monthend_series_cte.ending_month
      ORDER BY monthend_series_cte.ending_month
    ) AS total_monthly_change,
    SUM(monthly_balances_cte.transaction_balance) OVER (
      PARTITION BY monthend_series_cte.customer_id 
      ORDER BY monthend_series_cte.ending_month
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS ending_balance
  FROM monthend_series_cte
  LEFT JOIN monthly_balances_cte
    ON monthend_series_cte.ending_month = monthly_balances_cte.closing_month
    AND monthend_series_cte.customer_id = monthly_balances_cte.customer_id
)

-- Final query: Display the output of customer monthly statement with the ending balances. 
SELECT 
customer_id, 
  ending_month, 
  COALESCE(total_monthly_change, 0) AS total_monthly_change, 
  MIN(ending_balance) AS ending_balance
 FROM monthly_changes_cte
 GROUP BY 
  customer_id, ending_month, total_monthly_change
 ORDER BY 
  customer_id, ending_month;
```

**Answer:**

Showing results for customers ID 1, 2 and 3 only:
|customer_id|ending_month|total_monthly_change|ending_balance|
|:----|:----|:----|:----|
|1|2020-01-31T00:00:00.000Z|312|312|
|1|2020-02-29T00:00:00.000Z|0|312|
|1|2020-03-31T00:00:00.000Z|-952|-964|
|1|2020-04-30T00:00:00.000Z|0|-640|
|2|2020-01-31T00:00:00.000Z|549|549|
|2|2020-02-29T00:00:00.000Z|0|549|
|2|2020-03-31T00:00:00.000Z|61|610|
|2|2020-04-30T00:00:00.000Z|0|610|
|3|2020-01-31T00:00:00.000Z|144|144|
|3|2020-02-29T00:00:00.000Z|-965|-821|
|3|2020-03-31T00:00:00.000Z|-401|-1222|
|3|2020-04-30T00:00:00.000Z|493|-729|

***


WITH following_month_cte AS (
  SELECT
    customer_id, 
    ending_month, 
    ending_balance, 
    LEAD(ending_balance) OVER (
      PARTITION BY customer_id 
      ORDER BY ending_month) AS following_balance
  FROM ranked_monthly_balances
)
, variance_cte AS (
  SELECT 
    customer_id, 
    ending_month, 
    ROUND(100.0 * 
      (following_balance - ending_balance) / ending_balance,1) AS variance
  FROM following_month_cte  
  WHERE ending_month = '2020-01-31'
    AND following_balance::TEXT NOT LIKE '-%'
  GROUP BY 
    customer_id, ending_month, ending_balance, following_balance
  HAVING ROUND(100.0 * (following_balance - ending_balance) / ending_balance,1) > 5.0
)

SELECT 
  ROUND(100.0 * 
    COUNT(customer_id)
    / (SELECT COUNT(DISTINCT customer_id) 
    FROM ranked_monthly_balances),1) AS increase_5_percentage
FROM variance_cte; 
````

**Answer:**

|increase_5_percentage|
|:----|
|20.0|

- Among the customers, 20% experience a growth of more than 5% in their positive closing balance from the opening month to the following month.

**- What percentage of customers reduce their opening month’s positive closing balance by more than 5% in the following month?**

````sql
WITH following_month_cte AS (
  SELECT
    customer_id, 
    ending_month, 
    ending_balance, 
    LEAD(ending_balance) OVER (
      PARTITION BY customer_id 
      ORDER BY ending_month) AS following_balance
  FROM ranked_monthly_balances
)
, variance_cte AS (
  SELECT 
    customer_id, 
    ending_month, 
    ROUND((100.0 * 
      following_balance - ending_balance) / ending_balance,1) AS variance
  FROM following_month_cte  
  WHERE ending_month = '2020-01-31'
    AND following_balance::TEXT NOT LIKE '-%'
  GROUP BY 
    customer_id, ending_month, ending_balance, following_balance
  HAVING ROUND((100.0 * (following_balance - ending_balance)) / ending_balance,2) < 5.0
)

SELECT 
  ROUND(100.0 * 
    COUNT(customer_id)
    / (SELECT COUNT(DISTINCT customer_id) 
    FROM ranked_monthly_balances),1) AS reduce_5_percentage
FROM variance_cte; 
````

**Answer:**

|reduce_5_percentage|
|:----|
|25.6|

- Among the customers, 25.6% experience a drop of more than 5% in their positive closing balance from the opening month to the following month.

**- What percentage of customers move from a positive balance in the first month to a negative balance in the second month?**

````sql
WITH following_month_cte AS (
  SELECT
    customer_id, 
    ending_month, 
    ending_balance, 
    LEAD(ending_balance) OVER (
      PARTITION BY customer_id 
      ORDER BY ending_month) AS following_balance
  FROM ranked_monthly_balances
)
, variance_cte AS (
  SELECT *
  FROM following_month_cte
  WHERE ending_month = '2020-01-31'
    AND ending_balance::TEXT NOT LIKE '-%'
    AND following_balance::TEXT LIKE '-%'
)

SELECT 
  ROUND(100.0 * 
    COUNT(customer_id) 
    / (SELECT COUNT(DISTINCT customer_id) 
    FROM ranked_monthly_balances),1) AS positive_to_negative_percentage
FROM variance_cte;
````

**Answer:**

|positive_to_negative_percentage|
|:----|
|20.2|

- Among the customers, 20.2% transitioned from having a positive balance (`ending_balance`) in the first month to having a negative balance (`following_balance`) in the following month.

***
