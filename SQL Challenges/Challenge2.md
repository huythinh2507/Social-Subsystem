## A. Pizza Metrics

### 1. How many pizzas were ordered?

````sql
SELECT COUNT(*) AS total_pizzas_ordered
FROM customer_orders;
````

**Answer:**

| total_pizzas_ordered|
|---|
|14|

- Total of 14 pizzas were ordered.

### 2. How many unique customer orders were made?

````sql
SELECT COUNT(DISTINCT order_id) AS unique_customer_orders
FROM customer_orders;

````

**Answer:**

| total_pizzas_ordered|
|---|
|10|

- There are 10 unique customer orders.

### 3. How many successful orders were delivered by each runner?

````sql
SELECT runner_id, COUNT(*) AS successful_orders
FROM runner_orders
WHERE cancellation IS NULL OR cancellation = ''
GROUP BY runner_id;
````

**Answer:**
| runner_id | successful_orders |
| ----------- | ----------- |
| 1           | 3          |
| 2           | 1         |
| 3           | 1         |

- Runner 1 has 3 successful delivered orders.
- Runner 2 has 1 successful delivered orders.
- Runner 3 has 1 successful delivered order.

### 4. How many of each type of pizza was delivered?

````sql
SELECT 
  users.user_id, 
  users.email, 
  users.name, 
  users.role, 
  users.profile_pic, 
  users.phone_number
FROM 
  users
JOIN 
  follows ON users.user_id = follows.followee_id
WHERE 
  follows.follower_id = 1;

-- Query to retrieve a list of people that are following user 1
SELECT 
   users.user_id, 
  users.email, 
  users.name, 
  users.role, 
  users.profile_pic, 
  users.phone_number
FROM 
  users
JOIN 
  follows ON users.user_id = follows.follower_id
WHERE 
  follows.followee_id = 1;
````

**Answer:**
| pizza_name | number_delivered |
| ----------- | ----------- |
| Meatlovers           | 6          |
| Vegetarian           | 2         |

- There are 6 delivered Meatlovers pizzas and 2 Vegetarian pizzas.

### 5. How many Vegetarian and Meatlovers were ordered by each customer?**

````sql
SELECT customer_id, pizza_names.pizza_name, COUNT(customer_orders.pizza_id) AS number_ordered
FROM customer_orders
JOIN pizza_names ON customer_orders.pizza_id = pizza_names.pizza_id
GROUP BY customer_id, pizza_names.pizza_name
ORDER BY customer_id ASC;
````

**Answer:**
| customer_id | pizza_name  |number_ordered |
| ----------- | ----------- |-----------    |
| 101  |      Meatlovers           |2              |
| 101  |      Vegetarian      |1              |
| 102  |      Meatlovers         |2              |
| 102  |  Vegetarian          |1              |
| 103  |   Meatlovers         |3              |
| 103  | Vegetarian           |1              |
| 104  |  Meatlovers          |3              |
| 105  |  Vegetarian          |1              |

- Customer 101 ordered 2 Meatlovers pizzas and 1 Vegetarian pizza.
- Customer 102 ordered 2 Meatlovers pizzas and 1 Vegetarian pizzas.
- Customer 103 ordered 3 Meatlovers pizzas and 1 Vegetarian pizza.
- Customer 104 ordered 3 Meatlovers pizza.
- Customer 105 ordered 1 Vegetarian pizza.

### 6. What was the maximum number of pizzas delivered in a single order?

````sql
SELECT order_id, COUNT(pizza_id) AS pizzas_in_order
FROM customer_orders
GROUP BY order_id
ORDER BY pizzas_in_order DESC
LIMIT 1;
````

**Answer:**

| order_id | pizzas_in_order |
| ----------- | ----------- |
| 4           | 3          |

- Maximum number of pizza delivered in a single order is 3 pizzas.

### 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

````sql
SELECT customer_id,
       SUM(CASE WHEN exclusions != '' AND exclusions != 'null' OR extras != '' AND extras != 'null' THEN 1 ELSE 0 END) AS pizzas_with_changes,
       SUM(CASE WHEN exclusions = ''  AND extras = '' THEN 1 ELSE 0 END) AS pizzas_no_changes
FROM customer_orders
JOIN runner_orders ON customer_orders.order_id = runner_orders.order_id
WHERE runner_orders.cancellation IS NULL OR runner_orders.cancellation = '' OR runner_orders.cancellation = 'null'
GROUP BY customer_id
ORDER BY customer_id ASC;
````

**Answer:**
| customer_id | pizzas_with_changes  |pizzas_no_changes |
| ----------- | ----------- |-----------    |
| 101  |      0           |2              |
| 102  |      0         |2              |
| 103  |   3         |0            |
| 104  |  2          |0             |
| 105  |  1          |0            |


### 8. How many pizzas were delivered that had both exclusions and extras?

````sql
SELECT  
  SUM(
    CASE WHEN exclusions IS NOT NULL AND extras IS NOT NULL THEN 1
    ELSE 0
    END) AS pizza_count_w_exclusions_extras
FROM #customer_orders AS c
JOIN #runner_orders AS r
  ON c.order_id = r.order_id
WHERE r.distance >= 1 
  AND exclusions <> ' ' 
  AND extras <> ' ';
````

**Answer:**

![image](https://user-images.githubusercontent.com/81607668/129738278-dd3e7056-309d-42fc-a5e3-00f7b5d4609e.png)

- Only 1 pizza delivered that had both extra and exclusion topping. That’s one fussy customer!

### 9. What was the total volume of pizzas ordered for each hour of the day?

````sql
SELECT 
  DATEPART(HOUR, [order_time]) AS hour_of_day, 
  COUNT(order_id) AS pizza_count
FROM #customer_orders
GROUP BY DATEPART(HOUR, [order_time]);
````

**Answer:**

![image](https://user-images.githubusercontent.com/81607668/129738302-573430e9-1785-4c71-adc1-464ffa94de8a.png)

- Highest volume of pizza ordered is at 13 (1:00 pm), 18 (6:00 pm) and 21 (9:00 pm).
- Lowest volume of pizza ordered is at 11 (11:00 am), 19 (7:00 pm) and 23 (11:00 pm).

### 10. What was the volume of orders for each day of the week?

````sql
SELECT 
  FORMAT(DATEADD(DAY, 2, order_time),'dddd') AS day_of_week, -- add 2 to adjust 1st day of the week as Monday
  COUNT(order_id) AS total_pizzas_ordered
FROM #customer_orders
GROUP BY FORMAT(DATEADD(DAY, 2, order_time),'dddd');
````

**Answer:**

![image](https://user-images.githubusercontent.com/81607668/129738331-233744f6-3b57-4f4f-9a51-f7a699a9eb2e.png)

- There are 5 pizzas ordered on Friday and Monday.
- There are 3 pizzas ordered on Saturday.
- There is 1 pizza ordered on Sunday.

***

## B. Runner and Customer Experience

### 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

````sql
SELECT 
  DATEPART(WEEK, registration_date) AS registration_week,
  COUNT(runner_id) AS runner_signup
FROM runners
GROUP BY DATEPART(WEEK, registration_date);
````

**Answer:**

![image](https://user-images.githubusercontent.com/81607668/129739658-a233932a-9f79-4280-a618-8bab6d3bd1f2.png)

- On Week 1 of Jan 2021, 2 new runners signed up.
- On Week 2 and 3 of Jan 2021, 1 new runner signed up.

### 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

````sql
WITH time_taken_cte AS
(
  SELECT 
    c.order_id, 
    c.order_time, 
    r.pickup_time, 
    DATEDIFF(MINUTE, c.order_time, r.pickup_time) AS pickup_minutes
  FROM #customer_orders AS c
  JOIN #runner_orders AS r
    ON c.order_id = r.order_id
  WHERE r.distance != 0
  GROUP BY c.order_id, c.order_time, r.pickup_time
)

SELECT 
  AVG(pickup_minutes) AS avg_pickup_minutes
FROM time_taken_cte
WHERE pickup_minutes > 1;
````

**Answer:**

![image](https://user-images.githubusercontent.com/81607668/129739701-e94b75e9-7193-4cf3-8e77-3c76be8b638d.png)

- The average time taken in minutes by runners to arrive at Pizza Runner HQ to pick up the order is 15 minutes.

### 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?

````sql
WITH prep_time_cte AS
(
  SELECT 
    c.order_id, 
    COUNT(c.order_id) AS pizza_order, 
    c.order_time, 
    r.pickup_time, 
    DATEDIFF(MINUTE, c.order_time, r.pickup_time) AS prep_time_minutes
  FROM #customer_orders AS c
  JOIN #runner_orders AS r
    ON c.order_id = r.order_id
  WHERE r.distance != 0
  GROUP BY c.order_id, c.order_time, r.pickup_time
)

SELECT 
  pizza_order, 
  AVG(prep_time_minutes) AS avg_prep_time_minutes
FROM prep_time_cte
WHERE prep_time_minutes > 1
GROUP BY pizza_order;
````

**Answer:**

![image](https://user-images.githubusercontent.com/81607668/129739816-05e3ba03-d3fe-4206-8557-869930a897d1.png)

- On average, a single pizza order takes 12 minutes to prepare.
- An order with 3 pizzas takes 30 minutes at an average of 10 minutes per pizza.
- It takes 16 minutes to prepare an order with 2 pizzas which is 8 minutes per pizza — making 2 pizzas in a single order the ultimate efficiency rate.

### 4. Is there any relationship between the number of pizzas and how long the order takes to prepare?

````sql
SELECT 
  c.customer_id, 
  AVG(r.distance) AS avg_distance
FROM #customer_orders AS c
JOIN #runner_orders AS r
  ON c.order_id = r.order_id
WHERE r.duration != 0
GROUP BY c.customer_id;
````

**Answer:**

![image](https://user-images.githubusercontent.com/81607668/129739847-5e338f4f-b42c-4531-9685-e2e822063183.png)

_(Assuming that distance is calculated from Pizza Runner HQ to customer’s place)_

- Customer 104 stays the nearest to Pizza Runner HQ at average distance of 10km, whereas Customer 105 stays the furthest at 25km.

### 5. What was the difference between the longest and shortest delivery times for all orders?

_Edit 08/10/21: Thanks to my reader, Ankush Taneja on Medium who caught my mistake. I've amended to the correct solution. Also, I was doing this case study using SQL Server few months ago, but I'm using PostgreSQL on SQLpad now so there could be a slight difference to the syntax._

Firstly, I'm going to filter results with non-null duration first just to have a feel. You can skip this step and go straight to the answer.

````sql
SELECT 
  order_id, duration
FROM #runner_orders
WHERE duration not like ' ';
````

<img width="269" alt="image" src="https://user-images.githubusercontent.com/81607668/136523519-98efb655-d144-496b-a946-42c1c5415403.png">

```sql
SELECT MAX(duration::NUMERIC) - MIN(duration::NUMERIC) AS delivery_time_difference
FROM runner_orders2
where duration not like ' ';
```

**Answer:**

<img width="196" alt="image" src="https://user-images.githubusercontent.com/81607668/136523820-c4504a25-83f8-4236-b08e-37bf542caad0.png">

- The difference between longest (40 minutes) and shortest (10 minutes) delivery time for all orders is 30 minutes.

### 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?

````sql
SELECT 
  r.runner_id, 
  c.customer_id, 
  c.order_id, 
  COUNT(c.order_id) AS pizza_count, 
  r.distance, (r.duration / 60) AS duration_hr , 
  ROUND((r.distance/r.duration * 60), 2) AS avg_speed
FROM #runner_orders AS r
JOIN #customer_orders AS c
  ON r.order_id = c.order_id
WHERE distance != 0
GROUP BY r.runner_id, c.customer_id, c.order_id, r.distance, r.duration
ORDER BY c.order_id;
````

**Answer:**

![image](https://user-images.githubusercontent.com/81607668/129739931-54127037-0879-43bf-b53f-e4a1a6ebffeb.png)

_(Average speed = Distance in km / Duration in hour)_
- Runner 1’s average speed runs from 37.5km/h to 60km/h.
- Runner 2’s average speed runs from 35.1km/h to 93.6km/h. Danny should investigate Runner 2 as the average speed has a 300% fluctuation rate!
- Runner 3’s average speed is 40km/h

### 7. What is the successful delivery percentage for each runner?

````sql
SELECT 
  runner_id, 
  ROUND(100 * SUM(
    CASE WHEN distance = 0 THEN 0
    ELSE 1 END) / COUNT(*), 0) AS success_perc
FROM #runner_orders
GROUP BY runner_id;
````

**Answer:**

![image](https://user-images.githubusercontent.com/81607668/129740007-021d78fb-ec32-46c0-98f2-9e8f1891baed.png)

- Runner 1 has 100% successful delivery.
- Runner 2 has 75% successful delivery.
- Runner 3 has 50% successful delivery

_(It’s not right to attribute successful delivery to runners as order cancellations are out of the runner’s control.)_

***

## C. Ingredient Optimisation

### 1. What are the standard ingredients for each pizza?

### 2. What was the most commonly added extra?

```sql
WITH toppings_cte AS (
SELECT
  pizza_id,
  REGEXP_SPLIT_TO_TABLE(toppings, '[,\s]+')::INTEGER AS topping_id
FROM pizza_runner.pizza_recipes)

SELECT 
  t.topping_id, pt.topping_name, 
  COUNT(t.topping_id) AS topping_count
FROM toppings_cte t
INNER JOIN pizza_runner.pizza_toppings pt
  ON t.topping_id = pt.topping_id
GROUP BY t.topping_id, pt.topping_name
ORDER BY topping_count DESC;
```

**Solution**

<img width="582" alt="image" src="https://user-images.githubusercontent.com/81607668/138807557-08909e2e-8201-4e53-87b8-f927928292fb.png">

### 3. What was the most common exclusion?

### 4. Generate an order item for each record in the customers_orders table in the format of one of the following:
- Meat Lovers
- Meat Lovers - Exclude Beef
- Meat Lovers - Extra Bacon
- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

### 5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients

### 6. For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"

### 7. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

***

## D. Pricing and Ratings

1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
2. What if there was an additional $1 charge for any pizza extras?
- Add cheese is $1 extra
3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
- customer_id
- order_id
- runner_id
- rating
- order_time
- pickup_time
- Time between order and pickup
- Delivery duration
- Average speed
- Total number of pizzas
5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?
