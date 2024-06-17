## A. Customer Journey

## Based off the 8 sample customers provided in the sample subscriptions table below, write a brief description about each customer’s onboarding journey.

````sql
SELECT s.customer_id, p.plan_name, TO_CHAR(s.start_date, 'YYYY-MM-DD') AS start_date
FROM subscriptions s
JOIN plans p ON s.plan_id = p.plan_id
WHERE s.customer_id IN (1,2,3,4,5,6,7,8)
ORDER BY s.customer_id, s.start_date;

````
**Answer:**

| customer_id | plan_name     | start_date |
| ----------- | ------------- | ---------- |
| 1           | trial         | 2020-08-01 |
| 1           | basic monthly | 2020-08-08 |
| 2           | trial         | 2020-09-20 |
| 2           | pro annual    | 2020-09-27 |
| 3           | trial         | 2020-01-13 |
| 3           | basic monthly | 2020-01-20 |
| 4           | trial         | 2020-01-17 |
| 4           | basic monthly | 2020-01-24 |
| 4           | churn         | 2020-04-21 |
| 5           | trial         | 2020-08-03 |
| 5           | basic monthly | 2020-08-10 |
| 6           | trial         | 2020-12-23 |
| 6           | basic monthly | 2020-12-30 |
| 6           | churn         | 2021-02-26 |
| 7           | trial         | 2020-02-05 |
| 7           | basic monthly | 2020-02-12 |
| 7           | pro monthly   | 2020-05-22 |
| 8           | trial         | 2020-06-11 |
| 8           | basic monthly | 2020-06-18 |
| 8           | pro monthly   | 2020-08-03 |

- Customer 1: This customer initiated their journey by starting the free trial on 1 Aug 2020. After the trial period ended, on 8 Aug 2020, they subscribed to the basic monthly plan.
- Customer 2: Started with a trial on 20 Sep 2020 and upgraded to the pro annual plan on 27 Sep 2020.
- Customer 3: Began with a trial on 13 Jan 2020, then moved to the basic monthly plan on 20 Jan 2020.
- Customer 4: Entered the trial on 17 Jan 2020, switched to basic monthly on 24 Jan 2020, and later churned on 21 Apr 2020.
- Customer 5: Took the trial on 3 Aug 2020 and subsequently chose the basic monthly plan on 10 Aug 2020.
- Customer 6: Opted for the trial on 23 Dec 2020, continued with basic monthly from 30 Dec 2020, but eventually churned on 26 Feb 2021.
- Customer 7: Initiated with a trial on 5 Feb 2020, followed by basic monthly from 12 Feb 2020, and later upgraded to pro monthly on 22 May 2020.
- Customer 8: Started with a trial on 11 Jun 2020, then subscribed to basic monthly from 18 Jun 2020, and finally to pro monthly starting from 3 Aug 2020.

## B. Data Analysis Questions

### 1. How many customers has Foodie-Fi ever had?

```sql
SELECT COUNT(DISTINCT customer_id) AS num_of_customers
FROM foodie_fi.subscriptions;
```

**Answer:**
| num_of_customers | 
| ----------- | 
| 1000          |

- Foodie-Fi has 1,000 unique customers.

### 2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value

```sql
SELECT DATE_PART('month', start_date) AS month, COUNT(*) 
FROM subscriptions 
WHERE plan_id = 0 
GROUP BY month 
ORDER BY month;
```

**Answer:**

| 1  | 88 |   
|----|----|
| 2  | 68 |   
| 3  | 94 |   
| 4  | 81 |   
| 5  | 88 |   
| 6  | 79 |   
| 7  | 89 |  
| 8  | 88 |   
| 9  | 87 |  
| 10 | 79 |   
| 11 | 75 |   
| 12 | 84 |  

Among all the months, March has the highest number of trial plans, while February has the lowest number of trial plans.

### 3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name.

````sql
SELECT p.plan_name, COUNT(*) 
FROM subscriptions s
JOIN plans p ON s.plan_id = p.plan_id
WHERE s.start_date > '2020-12-31' 
GROUP BY p.plan_name;
````

**Answer:**

| plan_name     | count |   
|---------------|-------|
| pro annual    | 63    |  
| churn         | 71    | 
| pro monthly   | 60    |   
| basic monthly | 8     |   

### 4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?

```sql
SELECT COUNT(DISTINCT customer_id) AS total_customers,
       SUM(CASE WHEN plan_id = 4 THEN 1 ELSE 0 END) AS churned_customers,
       ROUND((SUM(CASE WHEN plan_id = 4 THEN 1 ELSE 0 END)::decimal / COUNT(DISTINCT customer_id)) * 100, 1) AS churn_percentage
FROM subscriptions;
```

**Answer:**

| total_customers | churned_customers | churn_percentage |   
|-----------------|-------------------|------------------|
| 1000            | 307               | 30.7             |

- Out of the total customer base of Foodie-Fi, 307 customers have churned. This represents approximately 30.7% of the overall customer count.

### 5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?

```sql
SELECT 
  COUNT(CASE 
    WHEN row_num = 2 AND plan_name = 'churn' THEN 1 
    ELSE NULL END) AS churned_customers,
  ROUND(100.0 * COUNT(
    CASE 
      WHEN row_num = 2 AND plan_name = 'churn' THEN 1 
      ELSE NULL END) 
    / (SELECT COUNT(DISTINCT customer_id) 
      FROM subscriptions), 2) AS churn_percentage
FROM (
  SELECT 
    sub.customer_id, 
    p.plan_id, 
    p.plan_name,
    ROW_NUMBER() OVER (
      PARTITION BY sub.customer_id 
      ORDER BY sub.start_date) AS row_num
  FROM subscriptions AS sub
  JOIN plans p
    ON sub.plan_id = p.plan_id
) AS ranked_subscriptions
WHERE plan_id = 4 -- Filter to churn plan.
  AND row_num = 2;
```
**Answer:**

| churned_customers | churn_percentage | 
|-----------------|-------------------|
| 92            | 9%               | 

- A total of 92 customers churned immediately after the initial free trial period, representing approximately 9% of the entire customer base.

### 6. What is the number and percentage of customer plans after their initial free trial?

```sql
WITH ranked_cte AS (
  SELECT 
    sub.customer_id, 
    p.plan_id, 
    p.plan_name,
    ROW_NUMBER() OVER (
      PARTITION BY sub.customer_id 
      ORDER BY sub.start_date) AS row_num
  FROM subscriptions AS sub
  JOIN plans p
    ON sub.plan_id = p.plan_id
)
  
SELECT 
  plan_name,
  COUNT(*) AS number_of_customers,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage_of_customers
FROM ranked_cte
WHERE row_num = 2 -- Customers' plans immediately after the trial ends.
GROUP BY plan_name;
```

**Answer:**

| plan_name     | number_of_customers | percentage_of_customers |
|---------------|---------------------|-------------------------|
| basic monthly | 546                 | 54.60                   |
| churn         | 92                  | 9.20                    |
| pro annual    | 37                  | 3.70                    |
| pro monthly   | 325                 | 32.50                   |


### 7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?

In the cte called `next_dates`, we begin by filtering the results to include only the plans with start dates on or before '2020-12-31'. To identify the next start date for each plan, we utilize the `LEAD()` window function.

In the outer query,  we filter the results where the `next_date` is NULL. This step helps us identify the most recent plan that each customer subscribed to as of '2020-12-31'. 

Lastly, we perform calculations to determine the total count of customers and the percentage of customers associated with each trial plan. 

```sql
SELECT 
  p.plan_name,
  COUNT(DISTINCT sub.customer_id) AS customer_count,
  ROUND(100.0 * COUNT(DISTINCT sub.customer_id) / SUM(COUNT(DISTINCT sub.customer_id)) OVER (), 2) AS customer_percentage
FROM subscriptions AS sub
JOIN plans p ON sub.plan_id = p.plan_id
WHERE sub.start_date <= '2020-12-31'

GROUP BY p.plan_name;
```

**Answer:**

| plan_name     | customer_count | customer_percentage |
|---------------|----------------|---------------------|
| basic monthly | 538            | 21.98               |
| churn         | 236            | 9.64                |
| pro annual    | 195            | 7.97                |
| pro monthly   | 479            | 19.57               |
| trial         | 1000           | 40.85               |

### 8. How many customers have upgraded to an annual plan in 2020?

```sql
SELECT COUNT(DISTINCT customer_id) 
FROM subscriptions 
WHERE plan_id IN (3) AND EXTRACT(YEAR FROM start_date) = 2020;
```

**Answer:**

| count     | 
|---------------|
| 195 |

### 9. How many days on average does it take for a customer to upgrade to an annual plan from the day they join Foodie-Fi?

This question is straightforward and the query provided is self-explanatory. 

````sql
WITH annual_upgrade AS (
    SELECT s.customer_id,
           MIN(s.start_date) AS join_date,
           MIN(s.start_date) FILTER (WHERE s.plan_id IN (3)) AS upgrade_to_annual_date
    FROM subscriptions s
    GROUP BY s.customer_id
)
SELECT AVG(upgrade_to_annual_date - join_date) AS average_days_to_upgrade
FROM annual_upgrade;
````

**Answer:**

| average_days_to_upgrade     | 
|---------------|
| 104.6201550387596899 |

- On average, customers take approximately 105 days from the day they join Foodie-Fi to upgrade to an annual plan.

### 10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)

To understand how the `WIDTH_BUCKET()` function works in creating buckets of 30-day periods, you can refer to this [StackOverflow](https://stackoverflow.com/questions/50518548/creating-a-bin-column-in-postgres-to-check-an-integer-and-return-a-string) answer.

```sql
SELECT 
  period_30_days,
  COUNT(*) AS number_of_customers
FROM (
  SELECT 
    sub.customer_id,
    FLOOR((sub.start_date - DATE '2020-01-01') / 30) AS period_30_days
  FROM subscriptions AS sub
  WHERE sub.start_date BETWEEN '2020-01-01' AND '2020-12-31'
) AS sub_periods
GROUP BY period_30_days
ORDER BY period_30_days;
```

**Answer:**

| period_30_days | number_of_customers |
|----------------|---------------------|
| 0              | 156                 |
| 1              | 151                 |
| 2              | 190                 |
| 3              | 193                 |
| 4              | 197                 |
| 5              | 208                 |
| 6              | 211                 |
| 7              | 229                 |
| 8              | 218                 |
| 9              | 230                 |
| 10             | 215                 |
| 11             | 212                 |
| 12             | 38                  |

### 11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

```sql
SELECT 
  COUNT(DISTINCT sub.customer_id) AS customers_downgraded
FROM subscriptions AS sub
WHERE sub.plan_id = 1
AND sub.start_date BETWEEN '2020-01-01' AND '2020-12-31'
AND EXISTS (
  SELECT 1
  FROM subscriptions AS prev_sub
  WHERE prev_sub.customer_id = sub.customer_id
  AND prev_sub.plan_id = 2
  AND prev_sub.start_date < sub.start_date
  AND NOT EXISTS (
    SELECT 1
    FROM subscriptions AS inter_sub
    WHERE inter_sub.customer_id = sub.customer_id
    AND inter_sub.plan_id != 2
    AND inter_sub.start_date < sub.start_date
    AND inter_sub.start_date > prev_sub.start_date
  )
);

```

**Answer:**

In 2020, there were no instances where customers downgraded from a pro monthly plan to a basic monthly plan.

***
