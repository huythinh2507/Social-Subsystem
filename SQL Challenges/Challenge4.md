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

````sql
WITH monthly_transactions AS (
  SELECT 
    customer_id, 
    EXTRACT(MONTH FROM txn_date) AS mth,
    COUNT(CASE WHEN txn_type = 'deposit' THEN 1 END) AS deposit_count,
    COUNT(CASE WHEN txn_type = 'purchase' THEN 1 END) AS purchase_count,
    COUNT(CASE WHEN txn_type = 'withdrawal' THEN 1 END) AS withdrawal_count
  FROM customer_transactions
  GROUP BY customer_id, EXTRACT(MONTH FROM txn_date)
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
|1|168|
|2|181|
|3|192|
|4|70|

***

**4. What is the closing balance for each customer at the end of the month?**

````sql
WITH first_deposit AS (
  SELECT 
    customer_id,
    MIN(txn_date) AS first_deposit_date,
    MIN(txn_amount) FILTER (WHERE txn_type = 'deposit') AS initial_balance
  FROM customer_transactions
  WHERE txn_type = 'deposit'
    AND customer_id IN (1, 2, 3)
  GROUP BY customer_id
)

SELECT 
  ct.customer_id,
  EXTRACT(YEAR FROM ct.txn_date) AS year,
  EXTRACT(MONTH FROM ct.txn_date) AS month,
  fd.initial_balance + SUM(CASE WHEN ct.txn_type = 'deposit' THEN ct.txn_amount ELSE 0 END) - 
  SUM(CASE WHEN ct.txn_type IN ('withdrawal', 'purchase') THEN ct.txn_amount ELSE 0 END) AS closing_balance
FROM customer_transactions ct
JOIN first_deposit fd ON ct.customer_id = fd.customer_id AND ct.txn_date >= fd.first_deposit_date
WHERE ct.customer_id IN (1, 2, 3)
GROUP BY ct.customer_id, month, year, fd.initial_balance;

````

**Answer:**

| customer_id 	| year 	| month 	| closing_balance 	|
|-------------	|------	|-------	|-----------------	|
| 1           	| 2020 	| 1     	| 624             	|
| 1           	| 2020 	| 3     	| -640            	|
| 2           	| 2020 	| 1     	| 610             	|
| 2           	| 2020 	| 3     	| 122             	|
| 3           	| 2020 	| 1     	| 288             	|
| 3           	| 2020 	| 2     	| -821            	|
| 3           	| 2020 	| 3     	| -257            	|
| 3           	| 2020 	| 4     	| 637             	|

**5. What is the percentage of customers who increase their closing balance by more than 5%?**

````sql
WITH first_deposit AS (
  SELECT 
    customer_id,
    MIN(txn_date) AS first_deposit_date,
    MIN(txn_amount) FILTER (WHERE txn_type = 'deposit') AS initial_balance
  FROM customer_transactions
  WHERE txn_type = 'deposit'
    AND customer_id IN (1, 2, 3)
  GROUP BY customer_id
),
monthly_balances AS (
  SELECT 
    ct.customer_id,
    EXTRACT(YEAR FROM ct.txn_date) AS year,
    EXTRACT(MONTH FROM ct.txn_date) AS month,
    fd.initial_balance,
    fd.initial_balance + SUM(CASE WHEN ct.txn_type = 'deposit' THEN ct.txn_amount ELSE 0 END) - 
    SUM(CASE WHEN ct.txn_type IN ('withdrawal', 'purchase') THEN ct.txn_amount ELSE 0 END) AS closing_balance
  FROM customer_transactions ct
  JOIN first_deposit fd ON ct.customer_id = fd.customer_id AND ct.txn_date >= fd.first_deposit_date
  WHERE ct.customer_id IN (1, 2, 3)
  GROUP BY ct.customer_id, year, month, fd.initial_balance
),
balance_increase AS (
  SELECT 
    customer_id,
    (closing_balance - initial_balance) / initial_balance * 100.0 AS balance_increase_percentage
  FROM monthly_balances
)

SELECT 
  ROUND((COUNT(*) FILTER (WHERE balance_increase_percentage > 5) * 100.0) / COUNT(*), 2) AS percentage_customers_increased_more_than_5
FROM balance_increase;
````

**Answer:**

| percentage_customers_increased_more_than_5 	| 
|-------------	|
| 62.50           	|

