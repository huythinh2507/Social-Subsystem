## 🏦 A. Customer Nodes Exploration

**1. How many unique nodes are there on the Data Bank system?**

````sql
DROP TABLE IF EXISTS clean_weekly_sales;
CREATE TEMP TABLE clean_weekly_sales AS (
SELECT
  TO_DATE(week_date, 'DD/MM/YY') AS week_date,
  DATE_PART('week', TO_DATE(week_date, 'DD/MM/YY')) AS week_number,
  DATE_PART('month', TO_DATE(week_date, 'DD/MM/YY')) AS month_number,
  DATE_PART('year', TO_DATE(week_date, 'DD/MM/YY')) AS calendar_year,
  region, 
  platform, 
  segment,
  CASE 
    WHEN RIGHT(segment,1) = '1' THEN 'Young Adults'
    WHEN RIGHT(segment,1) = '2' THEN 'Middle Aged'
    WHEN RIGHT(segment,1) in ('3','4') THEN 'Retirees'
    ELSE 'unknown' END AS age_band,
  CASE 
    WHEN LEFT(segment,1) = 'C' THEN 'Couples'
    WHEN LEFT(segment,1) = 'F' THEN 'Families'
    ELSE 'unknown' END AS demographic,
  transactions,
  ROUND((sales::NUMERIC/transactions),2) AS avg_transaction,
  sales
FROM weekly_sales
);
````
## 🛍 B. Data Exploration

**1. What day of the week is used for each week_date value?**

````sql
SELECT DISTINCT(TO_CHAR(week_date, 'day')) AS week_day 
FROM clean_weekly_sales;
````

**Answer:**

|week_day|
|:----|
|monday|

- Monday is used for the `week_date` value.

**2. What range of week numbers are missing from the dataset?**

````sql
WITH all_weeks AS (
  SELECT generate_series(1, 52) AS week_number
),
used_weeks AS (
  SELECT DISTINCT week_number FROM clean_weekly_sales
)
SELECT 
  all_weeks.week_number
FROM 
  all_weeks
LEFT JOIN used_weeks ON all_weeks.week_number = used_weeks.week_number
WHERE used_weeks.week_number IS NULL;
````

**Answer:**
|week_number|
|:----|
| week_number 	|
|-------------	|
| 1           	|
| 2           	|
| 3           	|
| 4           	|
| 5           	|
| 6           	|
| 7           	|
| 8           	|
| 9           	|
| 10          	|
| 11          	|
| 12          	|
| 37          	|
| 38          	|
| 39          	|
| 40          	|
| 41          	|
| 42          	|
| 43          	|
| 44          	|
| 45          	|
| 46          	|
| 47          	|
| 48          	|
| 49          	|
| 50          	|
| 51          	|
| 52          	|


**3. How many total transactions were there for each year in the dataset?**

````sql
SELECT 
  calendar_year, 
  SUM(transactions) AS total_transactions
FROM clean_weekly_sales
GROUP BY calendar_year;
````

**Answer:**

|calendar_year|total_transactions|
|:----|:----|
|2018|346406460|
|2019|365639285|
|2020|375813651|

**4. What is the total sales for each region for each month?**

````sql
SELECT 
  region, 
  month_number,
  SUM(sales) AS total_sales
FROM clean_weekly_sales
GROUP BY region, month_number
ORDER BY month_number asc;
````

**Answer:**
| region        	| month_number 	| total_sales 	|
|---------------	|--------------	|-------------	|
| USA           	| 3            	| 225353043   	|
| EUROPE        	| 3            	| 35337093    	|
| OCEANIA       	| 3            	| 783282888   	|
| AFRICA        	| 3            	| 567767480   	|
| SOUTH AMERICA 	| 3            	| 71023109    	|
| ASIA          	| 3            	| 529770793   	|
| CANADA        	| 3            	| 144634329   	|
| SOUTH AMERICA 	| 4            	| 238451531   	|
| AFRICA        	| 4            	| 1911783504  	|
| EUROPE        	| 4            	| 127334255   	|
| OCEANIA       	| 4            	| 2599767620  	|
| CANADA        	| 4            	| 484552594   	|
| ASIA          	| 4            	| 1804628707  	|
| USA           	| 4            	| 759786323   	|
| OCEANIA       	| 5            	| 2215657304  	|
| CANADA        	| 5            	| 412378365   	|
| ASIA          	| 5            	| 1526285399  	|
| EUROPE        	| 5            	| 109338389   	|
| USA           	| 5            	| 655967121   	|
| AFRICA        	| 5            	| 1647244738  	|
| SOUTH AMERICA 	| 5            	| 201391809   	|
| ASIA          	| 6            	| 1619482889  	|
| OCEANIA       	| 6            	| 2371884744  	|
| CANADA        	| 6            	| 443846698   	|
| AFRICA        	| 6            	| 1767559760  	|
| SOUTH AMERICA 	| 6            	| 218247455   	|
| EUROPE        	| 6            	| 122813826   	|
| USA           	| 6            	| 703878990   	|
| CANADA        	| 7            	| 477134947   	|
| SOUTH AMERICA 	| 7            	| 235582776   	|
| ASIA          	| 7            	| 1768844756  	|
| USA           	| 7            	| 760331754   	|
| EUROPE        	| 7            	| 136757466   	|
| OCEANIA       	| 7            	| 2563459400  	|
| AFRICA        	| 7            	| 1960219710  	|
| OCEANIA       	| 8            	| 2432313652  	|
| AFRICA        	| 8            	| 1809596890  	|
| CANADA        	| 8            	| 447073019   	|
| USA           	| 8            	| 712002790   	|
| EUROPE        	| 8            	| 122102995   	|
| ASIA          	| 8            	| 1663320609  	|
| SOUTH AMERICA 	| 8            	| 221166052   	|
| CANADA        	| 9            	| 69067959    	|
| EUROPE        	| 9            	| 18877433    	|
| SOUTH AMERICA 	| 9            	| 34175583    	|
| AFRICA        	| 9            	| 276320987   	|
| USA           	| 9            	| 110532368   	|
| OCEANIA       	| 9            	| 372465518   	|
| ASIA          	| 9            	| 252836807   	|

**5. What is the total count of transactions for each platform?**

````sql
SELECT 
  platform, 
  COUNT(*) AS total_transactions
FROM clean_weekly_sales
GROUP BY platform;
````

**Answer:**

|platform|total_transactions|
|:----|:----|
|Retail|8568|
|Shopify|8549|

**6. What is the percentage of sales for Retail vs Shopify for each month?**

````sql
SELECT 
  month_number,
  platform,
  SUM(sales) * 100.0 / SUM(SUM(sales)) OVER (PARTITION BY month_number) AS percentage_sales
FROM clean_weekly_sales
WHERE platform IN ('Retail', 'Shopify')
GROUP BY month_number, platform;
````

**Answer:**

| month_number 	| platform 	| percentage_sales    	|
|--------------	|----------	|---------------------	|
| 3            	| Retail   	| 97.5402559375962536 	|
| 3            	| Shopify  	| 2.4597440624037464  	|
| 4            	| Retail   	| 97.5939317095130930 	|
| 4            	| Shopify  	| 2.4060682904869070  	|
| 5            	| Retail   	| 97.3047013889549396 	|
| 5            	| Shopify  	| 2.6952986110450604  	|
| 6            	| Retail   	| 97.2713452528304812 	|
| 6            	| Shopify  	| 2.7286547471695188  	|
| 7            	| Retail   	| 97.2889092322482649 	|
| 7            	| Shopify  	| 2.7110907677517351  	|
| 8            	| Retail   	| 97.0823652866232413 	|
| 8            	| Shopify  	| 2.9176347133767587  	|
| 9            	| Retail   	| 97.3754376528184828 	|
| 9            	| Shopify  	| 2.6245623471815172  	|

**7. What is the percentage of sales by demographic for each year in the dataset?**

````sql
SELECT 
  calendar_year,
  demographic,
  SUM(sales) * 100.0 / SUM(SUM(sales)) OVER (PARTITION BY calendar_year) AS percentage_sales
FROM clean_weekly_sales
GROUP BY calendar_year, demographic;
````

**Answer:**

| calendar_year 	| demographic 	| percentage_sales    	|
|---------------	|-------------	|---------------------	|
| 2018          	| unknown     	| 41.6319730185788364 	|
| 2018          	| Families    	| 31.9875646717615528 	|
| 2018          	| Couples     	| 26.3804623096596107 	|
| 2019          	| Couples     	| 27.2751569225520164 	|
| 2019          	| unknown     	| 40.2506121020738166 	|
| 2019          	| Families    	| 32.4742309753741671 	|
| 2020          	| unknown     	| 38.5548279389012976 	|
| 2020          	| Couples     	| 28.7198828778632823 	|
| 2020          	| Families    	| 32.7252891832354201 	|

**8. Which age_band and demographic values contribute the most to Retail sales?**

````sql
SELECT 
  age_band, 
  demographic, 
  SUM(sales) AS retail_sales,
  ROUND(100 * 
    SUM(sales)::NUMERIC 
    / SUM(SUM(sales)) OVER (),
  1) AS contribution_percentage
FROM clean_weekly_sales
WHERE platform = 'Retail'
GROUP BY age_band, demographic
ORDER BY retail_sales DESC;
````

**Answer:**

| age_band     	| demographic 	| retail_sales 	| contribution_percentage 	|
|--------------	|-------------	|--------------	|-------------------------	|
| unknown      	| unknown     	| 16067285533  	| 40.5                    	|
| Retirees     	| Families    	| 6634686916   	| 16.7                    	|
| Retirees     	| Couples     	| 6370580014   	| 16.1                    	|
| Middle Aged  	| Families    	| 4354091554   	| 11.0                    	|
| Young Adults 	| Couples     	| 2602922797   	| 6.6                     	|
| Middle Aged  	| Couples     	| 1854160330   	| 4.7                     	|
| Young Adults 	| Families    	| 1770889293   	| 4.5                     	|


**9. Can we use the `avg_transaction` column to find the average transaction size for each year for Retail vs Shopify? If not - how would you calculate it instead?**

````sql
SELECT 
  calendar_year,
  platform,
  SUM(sales)/SUM(transactions) AS avg_transaction_size_per_year_platform
FROM clean_weekly_sales
WHERE platform IN ('Retail', 'Shopify')
GROUP BY calendar_year, platform;
````

**Answer:**

| calendar_year 	| platform 	| avg_transaction_size_per_year_platform 	|
|---------------	|----------	|----------------------------------------	|
| 2018          	| Retail   	| 36                                     	|
| 2018          	| Shopify  	| 192                                    	|
| 2019          	| Retail   	| 36                                     	|
| 2019          	| Shopify  	| 183                                    	|
| 2020          	| Retail   	| 36                                     	|
| 2020          	| Shopify  	| 179                                    	|


***

## 🧼 C. Before & After Analysis

**1. What is the total sales for the 4 weeks before and after `2020-06-15`? What is the growth or reduction rate in actual values and percentage of sales?**

````sql
WITH date_ranges AS (
  SELECT 
    '2020-06-15'::DATE - INTERVAL '4 weeks' AS start_date,
    '2020-06-15'::DATE + INTERVAL '4 weeks' AS end_date
),
sales_before AS (
  SELECT SUM(sales) AS total_sales_before
  FROM clean_weekly_sales
  WHERE week_date BETWEEN (SELECT start_date FROM date_ranges) AND '2020-06-15'
),
sales_after AS (
  SELECT SUM(sales) AS total_sales_after
  FROM clean_weekly_sales
  WHERE week_date > '2020-06-15' AND week_date <= (SELECT end_date FROM date_ranges)
)
SELECT 
  total_sales_before,
  total_sales_after,
  total_sales_after - total_sales_before AS actual_growth_reduction,
  (total_sales_after - total_sales_before)::DECIMAL / total_sales_before * 100.0 AS percentage_growth_reduction
FROM sales_before, sales_after;
````

**Answer:**

| total_sales_before 	| total_sales_after 	| actual_growth_reduction 	| percentage_growth_reduction 	|
|--------------------	|-------------------	|-------------------------	|-----------------------------	|
| 2915903705         	| 2334905223        	| -580998482              	| -19.92                       	|

***

**2. What about the entire 12 weeks before and after?**

````sql
WITH date_ranges AS (
  SELECT 
    '2020-06-15'::DATE - INTERVAL '12 weeks' AS start_date,
    '2020-06-15'::DATE + INTERVAL '12 weeks' AS end_date
),
sales_before AS (
  SELECT SUM(sales) AS total_sales_before
  FROM clean_weekly_sales
  WHERE week_date BETWEEN (SELECT start_date FROM date_ranges) AND '2020-06-15'
),
sales_after AS (
  SELECT SUM(sales) AS total_sales_after
  FROM clean_weekly_sales
  WHERE week_date > '2020-06-15' AND week_date <= (SELECT end_date FROM date_ranges)
)
SELECT 
  total_sales_before,
  total_sales_after,
  total_sales_after - total_sales_before AS actual_growth_reduction,
  (total_sales_after - total_sales_before) / total_sales_before * 100.0 AS percentage_growth_reduction
FROM sales_before, sales_after;
````

**Answer:**

| total_sales_before 	| total_sales_after 	| actual_growth_reduction 	| percentage_growth_reduction 	|
|--------------------	|-------------------	|-------------------------	|-----------------------------	|
| 7696298495         	| 6403922405        	| -1292376090              	| -16.8%                         	|

***

**3. How do the sale metrics for these 2 periods before and after compare with the previous years in 2018 and 2019?**

````sql
WITH date_ranges AS (
  SELECT 
    '2020-06-15'::DATE - INTERVAL '4 weeks' AS start_date_2020,
    '2020-06-15'::DATE + INTERVAL '4 weeks' AS end_date_2020,
    '2019-06-15'::DATE - INTERVAL '4 weeks' AS start_date_2019,
    '2019-06-15'::DATE + INTERVAL '4 weeks' AS end_date_2019,
    '2018-06-15'::DATE - INTERVAL '4 weeks' AS start_date_2018,
    '2018-06-15'::DATE + INTERVAL '4 weeks' AS end_date_2018
),
sales_2020 AS (
  SELECT 
    SUM(CASE WHEN week_date BETWEEN dr.start_date_2020 AND '2020-06-15' THEN sales ELSE 0 END) AS total_sales_before_2020,
    SUM(CASE WHEN week_date > '2020-06-15' AND week_date <= dr.end_date_2020 THEN sales ELSE 0 END) AS total_sales_after_2020
  FROM clean_weekly_sales, (SELECT * FROM date_ranges) dr
  WHERE week_date BETWEEN dr.start_date_2020 AND dr.end_date_2020
),
sales_2019 AS (
  SELECT 
    SUM(CASE WHEN week_date BETWEEN dr.start_date_2019 AND '2019-06-15' THEN sales ELSE 0 END) AS total_sales_before_2019,
    SUM(CASE WHEN week_date > '2019-06-15' AND week_date <= dr.end_date_2019 THEN sales ELSE 0 END) AS total_sales_after_2019
  FROM clean_weekly_sales, (SELECT * FROM date_ranges) dr
  WHERE week_date BETWEEN dr.start_date_2019 AND dr.end_date_2019
),
sales_2018 AS (
  SELECT 
    SUM(CASE WHEN week_date BETWEEN dr.start_date_2018 AND '2018-06-15' THEN sales ELSE 0 END) AS total_sales_before_2018,
    SUM(CASE WHEN week_date > '2018-06-15' AND week_date <= dr.end_date_2018 THEN sales ELSE 0 END) AS total_sales_after_2018
  FROM clean_weekly_sales, (SELECT * FROM date_ranges) dr
  WHERE week_date BETWEEN dr.start_date_2018 AND dr.end_date_2018
)
SELECT 
  total_sales_before_2020,
  total_sales_after_2020,
  total_sales_before_2019,
  total_sales_after_2019,
  total_sales_before_2018,
  total_sales_after_2018
FROM sales_2020, sales_2019, sales_2018;
````

**Answer:**

| total_sales_before_2020 	| total_sales_after_2020 	| total_sales_before_2019 	| total_sales_after_2019 	| total_sales_before_2018 	| total_sales_after_2018 	|
|-------------------------	|------------------------	|-------------------------	|------------------------	|-------------------------	|------------------------	|
| 2915903705              	| 2334905223             	| 2249989796              	| 2252326390             	| 2125140809              	| 2129242914             	|
