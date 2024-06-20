## 🧼 A. Data Exploration and Cleansing

**1. Update the `fresh_segments.interest_metrics` table by modifying the `month_year` column to be a `date` data type with the start of the month**

```sql
ALTER TABLE fresh_segments.interest_metrics
ALTER month_year TYPE VARCHAR USING to_char(to_date(month_year, 'MM-YYYY'), 'YYYY-MM-DD');


SELECT * FROM fresh_segments.interest_metrics LIMIT 10;
```

| _month 	| _year 	| month_year 	| interest_id 	| composition 	| index_value 	| ranking 	| percentile_ranking 	|
|--------	|-------	|------------	|-------------	|-------------	|-------------	|---------	|--------------------	|
| 7      	| 2018  	| 2018-07-01 	| 32486       	| 11.89       	| 6.19        	| 1       	| 99.86              	|
| 7      	| 2018  	| 2018-07-01 	| 6106        	| 9.93        	| 5.31        	| 2       	| 99.73              	|
| 7      	| 2018  	| 2018-07-01 	| 18923       	| 10.85       	| 5.29        	| 3       	| 99.59              	|
| 7      	| 2018  	| 2018-07-01 	| 6344        	| 10.32       	| 5.1         	| 4       	| 99.45              	|
| 7      	| 2018  	| 2018-07-01 	| 100         	| 10.77       	| 5.04        	| 5       	| 99.31              	|
| 7      	| 2018  	| 2018-07-01 	| 69          	| 10.82       	| 5.03        	| 6       	| 99.18              	|
| 7      	| 2018  	| 2018-07-01 	| 79          	| 11.21       	| 4.97        	| 7       	| 99.04              	|
| 7      	| 2018  	| 2018-07-01 	| 6111        	| 10.71       	| 4.83        	| 8       	| 98.9               	|
| 7      	| 2018  	| 2018-07-01 	| 6214        	| 9.71        	| 4.83        	| 8       	| 98.9               	|
| 7      	| 2018  	| 2018-07-01 	| 19422       	| 10.11       	| 4.81        	| 10      	| 98.63              	|
***
  
**2. What is count of records in the `fresh_segments.interest_metrics` for each `month_year` value sorted in chronological order (earliest to latest) with the `null` values appearing first?**

```sql
SELECT 
  month_year,
  COUNT(*) AS record_count
FROM 
  fresh_segments.interest_metrics
GROUP BY 
  month_year
ORDER BY 
  CASE WHEN month_year IS NULL THEN 0 ELSE 1 END,
  month_year;
```
| month_year 	| record_count 	|
|------------	|--------------	|
| null       	| 1194         	|
| 2018-07-01 	| 729          	|
| 2018-08-01 	| 767          	|
| 2018-09-01 	| 780          	|
| 2018-10-01 	| 857          	|
| 2018-11-01 	| 928          	|
| 2018-12-01 	| 995          	|
| 2019-01-01 	| 973          	|
| 2019-02-01 	| 1121         	|
| 2019-03-01 	| 1136         	|
| 2019-04-01 	| 1099         	|
| 2019-05-01 	| 857          	|
| 2019-06-01 	| 824          	|
| 2019-07-01 	| 864          	|
| 2019-08-01 	| 1149         	|

**3. What do you think we should do with these `null` values in the `fresh_segments.interest_metrics`?**

The `null` values appear in `_month`, `_year`, `month_year`, and `interest_id`. The corresponding values in `composition`, `index_value`, `ranking`, and `percentile_ranking` fields are not meaningful without the specific information on `interest_id` and dates. 

Before dropping the values, it would be useful to find out the percentage of `null` values.

```sql
SELECT 
  ROUND(100 * (SUM(CASE WHEN _month IS NULL THEN 1 ELSE 0 END) * 1.0 / COUNT(*)), 2) AS month_null_perc,
  ROUND(100 * (SUM(CASE WHEN _year IS NULL THEN 1 ELSE 0 END) * 1.0 / COUNT(*)), 2) AS year_null_perc,
  ROUND(100 * (SUM(CASE WHEN month_year IS NULL THEN 1 ELSE 0 END) * 1.0 / COUNT(*)), 2) AS month_year_null_perc,
  ROUND(100 * (SUM(CASE WHEN interest_id IS NULL THEN 1 ELSE 0 END) * 1.0 / COUNT(*)), 2) AS interest_id_null_perc
FROM 
  fresh_segments.interest_metrics;

```

| month_null_perc 	| year_null_perc 	| month_year_null_perc 	| interest_id_null_perc 	|
|-----------------	|----------------	|----------------------	|-----------------------	|
| 8.37            	| 8.37           	| 8.37                 	| 8.36                  	|

The percentage of null values is 8.37%. We're gonna delete these 'null' values.

```sql
DELETE FROM fresh_segments.interest_metrics
WHERE interest_id IS NULL;

SELECT 
  ROUND(100 * (SUM(CASE WHEN _month IS NULL THEN 1 ELSE 0 END) * 1.0 / COUNT(*)), 2) AS month_null_perc,
  ROUND(100 * (SUM(CASE WHEN _year IS NULL THEN 1 ELSE 0 END) * 1.0 / COUNT(*)), 2) AS year_null_perc,
  ROUND(100 * (SUM(CASE WHEN month_year IS NULL THEN 1 ELSE 0 END) * 1.0 / COUNT(*)), 2) AS month_year_null_perc,
  ROUND(100 * (SUM(CASE WHEN interest_id IS NULL THEN 1 ELSE 0 END) * 1.0 / COUNT(*)), 2) AS interest_id_null_perc
FROM 
  fresh_segments.interest_metrics;
```

| month_null_perc 	| year_null_perc 	| month_year_null_perc 	| interest_id_null_perc 	|
|-----------------	|----------------	|----------------------	|-----------------------	|
| 0           	| 0           	| 0                 	| 0                 	|

***
  
**4. How many `interest_id` values exist in the `fresh_segments.interest_metrics` table but not in the `fresh_segments.interest_map` table? What about the other way around?**

```sql
SELECT 
  COUNT(DISTINCT map.id) AS map_id_count,
  COUNT(DISTINCT metrics.interest_id) AS metrics_id_count,
  SUM(CASE WHEN map.id is NULL THEN 1 END) AS not_in_metric,
  SUM(CASE WHEN metrics.interest_id is NULL THEN 1 END) AS not_in_map
FROM fresh_segments.interest_map map
FULL OUTER JOIN fresh_segments.interest_metrics metrics
  ON metrics.interest_id = map.id;
```

| map_id_count 	| metrics_id_count 	| not_in_metric 	| not_in_map 	|
|--------------	|------------------	|---------------	|------------	|
| 1209         	| 1202             	| 0             	| 7          	|

***
  
**5. Summarise the id values in the `fresh_segments.interest_map` by its total record count in this table.**

```sql
SELECT COUNT(*)
FROM fresh_segments.interest_map;
```

| id_count 	|
|--------------	|
| 1209         	|
***
  
**6. What sort of table join should we perform for our analysis and why? Check your logic by checking the rows where 'interest_id = 21246' in your joined output and include all columns from `fresh_segments.interest_metrics` and all columns from `fresh_segments.interest_map` except from the id column.**

We should be using `INNER JOIN` to perform our analysis.

```sql
SELECT im.*, 
       map.interest_name, 
       map.interest_summary, 
       map.created_at, 
       map.last_modified
FROM fresh_segments.interest_metrics im
INNER JOIN fresh_segments.interest_map map ON im.interest_id::INTEGER = map.id
WHERE im.interest_id = '21246';
```

| _month 	| _year 	| month_year 	| interest_id 	| composition 	| index_value 	| ranking 	| percentile_ranking 	| interest_name                    	| interest_summary                                      	| created_at               	| last_modified            	|
|--------	|-------	|------------	|-------------	|-------------	|-------------	|---------	|--------------------	|----------------------------------	|-------------------------------------------------------	|--------------------------	|--------------------------	|
| null   	| null  	| null       	| 21246       	| 1.61        	| 0.68        	| 1191    	| 0.25               	| Readers of El Salvadoran Content 	| People reading news from El Salvadoran media sources. 	| 2018-06-11T17:50:04.000Z 	| 2018-06-11T17:50:04.000Z 	|
| 4      	| 2019  	| 2019-04-01 	| 21246       	| 1.58        	| 0.63        	| 1092    	| 0.64               	| Readers of El Salvadoran Content 	| People reading news from El Salvadoran media sources. 	| 2018-06-11T17:50:04.000Z 	| 2018-06-11T17:50:04.000Z 	|
| 3      	| 2019  	| 2019-03-01 	| 21246       	| 1.75        	| 0.67        	| 1123    	| 1.14               	| Readers of El Salvadoran Content 	| People reading news from El Salvadoran media sources. 	| 2018-06-11T17:50:04.000Z 	| 2018-06-11T17:50:04.000Z 	|
| 2      	| 2019  	| 2019-02-01 	| 21246       	| 1.84        	| 0.68        	| 1109    	| 1.07               	| Readers of El Salvadoran Content 	| People reading news from El Salvadoran media sources. 	| 2018-06-11T17:50:04.000Z 	| 2018-06-11T17:50:04.000Z 	|
| 1      	| 2019  	| 2019-01-01 	| 21246       	| 2.05        	| 0.76        	| 954     	| 1.95               	| Readers of El Salvadoran Content 	| People reading news from El Salvadoran media sources. 	| 2018-06-11T17:50:04.000Z 	| 2018-06-11T17:50:04.000Z 	|
| 12     	| 2018  	| 2018-12-01 	| 21246       	| 1.97        	| 0.7         	| 983     	| 1.21               	| Readers of El Salvadoran Content 	| People reading news from El Salvadoran media sources. 	| 2018-06-11T17:50:04.000Z 	| 2018-06-11T17:50:04.000Z 	|
| 11     	| 2018  	| 2018-11-01 	| 21246       	| 2.25        	| 0.78        	| 908     	| 2.16               	| Readers of El Salvadoran Content 	| People reading news from El Salvadoran media sources. 	| 2018-06-11T17:50:04.000Z 	| 2018-06-11T17:50:04.000Z 	|
| 10     	| 2018  	| 2018-10-01 	| 21246       	| 1.74        	| 0.58        	| 855     	| 0.23               	| Readers of El Salvadoran Content 	| People reading news from El Salvadoran media sources. 	| 2018-06-11T17:50:04.000Z 	| 2018-06-11T17:50:04.000Z 	|
| 9      	| 2018  	| 2018-09-01 	| 21246       	| 2.06        	| 0.61        	| 774     	| 0.77               	| Readers of El Salvadoran Content 	| People reading news from El Salvadoran media sources. 	| 2018-06-11T17:50:04.000Z 	| 2018-06-11T17:50:04.000Z 	|
| 8      	| 2018  	| 2018-08-01 	| 21246       	| 2.13        	| 0.59        	| 765     	| 0.26               	| Readers of El Salvadoran Content 	| People reading news from El Salvadoran media sources. 	| 2018-06-11T17:50:04.000Z 	| 2018-06-11T17:50:04.000Z 	|
| 7      	| 2018  	| 2018-07-01 	| 21246       	| 2.26        	| 0.65        	| 722     	| 0.96               	| Readers of El Salvadoran Content 	| People reading news from El Salvadoran media sources. 	| 2018-06-11T17:50:04.000Z 	| 2018-06-11T17:50:04.000Z 	|

***

**7. Are there any records in your joined table where the `month_year` value is before the `created_at` value from the `fresh_segments.interest_map` table? Do you think these values are valid and why?**

```sql
SELECT COUNT(*)
FROM fresh_segments.interest_metrics im
INNER JOIN fresh_segments.interest_map map ON im.interest_id::INTEGER = map.id
WHERE im.month_year::DATE < map.created_at;
```

| count 	      |
|--------------	|
| 188         	|

***

## 📚 B. Interest Analysis
  
**1. Which interests have been present in all `month_year` dates in our dataset?**

Find out how many unique `month_year` in dataset.

```sql
SELECT 
  COUNT(DISTINCT month_year) AS unique_month_year_count, 
  COUNT(DISTINCT interest_id) AS unique_interest_id_count
FROM fresh_segments.interest_metrics;
```

| unique_month_year_count 	| unique_interest_id_count 	|
|-------------------------	|--------------------------	|
| 14                      	| 1202                     	|

There are 14 distinct `month_year` dates and 1202 distinct `interest_id`s.

```sql
SELECT 
  total_months,
  COUNT(DISTINCT interest_id) AS interest_count
FROM (
  SELECT 
    interest_id, 
    COUNT(DISTINCT month_year) AS total_months
  FROM fresh_segments.interest_metrics
  WHERE month_year IS NOT NULL
  GROUP BY interest_id
) AS subquery
WHERE total_months = 14
GROUP BY total_months
ORDER BY interest_count DESC;

```
| total_months 	| interest_count 	|
|--------------	|----------------	|
| 14           	| 480            	|

***
  
**2. Using this same total_months measure - calculate the cumulative percentage of all records starting at 14 months - which total_months value passes the 90% cumulative percentage value?**

```sql
WITH cte_interest_months AS (
  SELECT
    interest_id,
    COUNT(DISTINCT month_year) AS total_months
  FROM fresh_segments.interest_metrics
  WHERE interest_id IS NOT NULL
  GROUP BY interest_id
),
cte_interest_counts AS (
  SELECT
    total_months,
    COUNT(DISTINCT interest_id) AS interest_count
  FROM cte_interest_months
  GROUP BY total_months
),
cte_cumulative AS (
  SELECT
    total_months,
    interest_count,
    ROUND(100 * SUM(interest_count) OVER (ORDER BY total_months DESC) /
        (SUM(interest_count) OVER ()),2) AS cumulative_percentage
  FROM cte_interest_counts
)

SELECT *
FROM cte_cumulative
WHERE cumulative_percentage > 90;
```

| total_months 	| interest_count 	| cumulative_percentage 	|
|--------------	|----------------	|-----------------------	|
| 6            	| 33             	| 90.85                 	|
| 5            	| 38             	| 94.01                 	|
| 4            	| 32             	| 96.67                 	|
| 3            	| 15             	| 97.92                 	|
| 2            	| 12             	| 98.92                 	|
| 1            	| 13             	| 100.00                	|


**3. If we were to remove all `interest_id` values which are lower than the `total_months` value we found in the previous question - how many total data points would we be removing?**

```sql
with month_counts as
(
select interest_id, count(distinct month_year) as month_count
from 
fresh_segments.interest_metrics
group by interest_id
having count(distinct month_year) <6 
)

--getting the number of times the above interest ids are present in the interest_metrics table
select count(interest_id) as interest_record_to_remove
from fresh_segments.interest_metrics
where interest_id in (select interest_id from month_counts)
```
| interest_record_to_remove 	|
|---------------------------	|
| 400                       	|

***

**4. Does this decision make sense to remove these data points from a business perspective? Use an example where there are all 14 months present to a removed interest example for your arguments - think about what it means to have less months present from a segment perspective. **

***

**5. If we include all of our interests regardless of their counts - how many unique interests are there for each month?**
  
***

## 🧩 C. Segment Analysis
 
**1. Using the complete dataset - which are the top 10 and bottom 10 interests which have the largest composition values in any month_year? Only use the maximum composition value for each interest but you must keep the corresponding month_year**
```sql
CREATE TABLE filtered_table AS
SELECT *
FROM fresh_segments.interest_metrics
WHERE interest_id IN (
  SELECT interest_id
  FROM (
    SELECT interest_id, COUNT(DISTINCT month_year) AS month_count
    FROM fresh_segments.interest_metrics
    GROUP BY interest_id
    HAVING COUNT(DISTINCT month_year) >= 6 
  ) AS cte
);
-- Querying from filtered_table

-- For top 10 
SELECT month_year, f.interest_id, interest_name, MAX(composition) AS max_composition
FROM filtered_table f
JOIN fresh_segments.interest_map ma ON f.interest_id = ma.id::VARCHAR -- Cast integer to VARCHAR
GROUP BY month_year, f.interest_id, interest_name
ORDER BY max_composition DESC
LIMIT 10;

-- For bottom 10
SELECT month_year, f.interest_id, interest_name, MAX(composition) AS max_composition
FROM filtered_table f
JOIN fresh_segments.interest_map ma ON f.interest_id = ma.id::VARCHAR -- Cast integer to VARCHAR
GROUP BY month_year, f.interest_id, interest_name
ORDER BY max_composition ASC
LIMIT 10;
```
| month_year 	| interest_id 	| interest_name                     	| max_composition 	|
|------------	|-------------	|-----------------------------------	|-----------------	|
| 12-2018    	| 21057       	| Work Comes First Travelers        	| 21.2            	|
| 10-2018    	| 21057       	| Work Comes First Travelers        	| 20.28           	|
| 11-2018    	| 21057       	| Work Comes First Travelers        	| 19.45           	|
| 01-2019    	| 21057       	| Work Comes First Travelers        	| 18.99           	|
| 07-2018    	| 6284        	| Gym Equipment Owners              	| 18.82           	|
| 02-2019    	| 21057       	| Work Comes First Travelers        	| 18.39           	|
| 09-2018    	| 21057       	| Work Comes First Travelers        	| 18.18           	|
| 07-2018    	| 39          	| Furniture Shoppers                	| 17.44           	|
| 07-2018    	| 77          	| Luxury Retail Shoppers            	| 17.19           	|
| 10-2018    	| 12133       	| Luxury Boutique Hotel Researchers 	| 15.15           	|

| month_year 	| interest_id 	| interest_name                	| max_composition 	|
|------------	|-------------	|------------------------------	|-----------------	|
| 05-2019    	| 45524       	| Mowing Equipment Shoppers    	| 1.51            	|
| 05-2019    	| 20768       	| Beer Aficionados             	| 1.52            	|
| 04-2019    	| 44449       	| United Nations Donors        	| 1.52            	|
| 05-2019    	| 39336       	| Philadelphia 76ers Fans      	| 1.52            	|
| 06-2019    	| 35742       	| Disney Fans                  	| 1.52            	|
| 06-2019    	| 34083       	| New York Giants Fans         	| 1.52            	|
| 05-2019    	| 4918        	| Gastrointestinal Researchers 	| 1.52            	|
| 05-2019    	| 6127        	| LED Lighting Shoppers        	| 1.53            	|
| 05-2019    	| 36877       	| Crochet Enthusiasts          	| 1.53            	|
| 06-2019    	| 6314        	| Online Directory Searchers   	| 1.53            	|

***

2. Which 5 interests had the lowest average ranking value?
```sql
SELECT
    DISTINCT interest_id,
    AVG(ranking) OVER(PARTITION BY interest_id) AS avg_ranking
FROM
    filtered_table
ORDER BY avg_ranking
LIMIT 5
```
| interest_id 	| avg_ranking            	|
|-------------	|------------------------	|
| 41548       	| 1.00000000000000000000 	|
| 42203       	| 4.1111111111111111     	|
| 115         	| 5.9285714285714286     	|
| 171         	| 9.3571428571428571     	|
| 6206        	| 11.8571428571428571    	|

3. Which 5 interests had the largest standard deviation in their percentile_ranking value?
```sql
SELECT
    interest_id,
	STDDEV(percentile_ranking) AS standard_deviation
FROM
    filtered_table
GROUP BY interest_id
ORDER BY standard_deviation DESC
LIMIT 5
```
| interest_id 	| standard_deviation 	|
|-------------	|--------------------	|
| 23          	| 30.175047086403474 	|
| 20764       	| 28.97491995962485  	|
| 38992       	| 28.318455623301364 	|
| 43546       	| 26.242685919808476 	|
| 10839       	| 25.612267373272523 	|

4. For the 5 interests found in the previous question - what was minimum and maximum percentile_ranking values for each interest and its corresponding year_month value? Can you describe what is happening for these 5 interests?
```sql
WITH top_5_stddev AS
(SELECT
    interest_id,
	STDDEV(percentile_ranking) AS standard_deviation
FROM
    filtered_table
GROUP BY interest_id
ORDER BY standard_deviation DESC
LIMIT 5)
SELECT
	interest_id,
    MIN(percentile_ranking) AS minimum_pr,
    MAX(percentile_ranking) AS maximum_pr
FROM filtered_table
WHERE interest_id IN (SELECT interest_id FROM top_5_stddev)
GROUP BY interest_id
```
| interest_id 	| minimum_pr 	| maximum_pr 	|
|-------------	|------------	|------------	|
| 43546       	| 5.7        	| 73.15      	|
| 23          	| 7.92       	| 86.69      	|
| 20764       	| 11.23      	| 86.15      	|
| 38992       	| 2.2        	| 82.44      	|
| 10839       	| 4.84       	| 75.03      	|

5. How would you describe our customers in this segment based off their composition and ranking values? What sort of products or services should we show to these customers and what should we avoid?
```sql
SELECT
	interest_id,
    interest_name,
    interest_summary,
    AVG(composition) AS avg_composition,
    AVG(ranking) AS avg_ranking
FROM
	filtered_table AS filtered_metric
JOIN fresh_segments.interest_map AS map ON filtered_metric.interest_id = map.id
GROUP BY interest_id,
		interest_name,
		interest_summary
ORDER BY avg_composition DESC, avg_ranking ASC
LIMIT 10
```
| interest_id 	| interest_name                                	| interest_summary                                                                                                                                 	| avg_composition 	| avg_ranking 	|
|-------------	|----------------------------------------------	|--------------------------------------------------------------------------------------------------------------------------------------------------	|-----------------	|-------------	|
| 21057       	| Work Comes First Travelers                   	| People looking to book a hotel who travel frequently for business and vacation.                                                                  	| 17.5            	| 47.5        	|
| 5969        	| Luxury Bedding Shoppers                      	| Consumers shopping for luxury bedding.                                                                                                           	| 11.1            	| 59          	|
| 6284        	| Gym Equipment Owners                         	| People researching and comparing fitness trends and techniques. These consumers are more likely to spend money on gym equipment for their homes. 	| 10.5            	| 50.1        	|
| 12133       	| Luxury Boutique Hotel Researchers            	| Consumers comparing or purchasing accommodations at luxury, boutique hotels.                                                                     	| 10.4            	| 28.9        	|
| 77          	| Luxury Retail Shoppers                       	| Consumers shopping for high end fashion apparel and accessories.                                                                                 	| 9.8             	| 71.9        	|
| 19298       	| Beach Supplies Shoppers                      	| Consumers shopping for beach supplies.                                                                                                           	| 9.5             	| 35.6        	|
| 39          	| Furniture Shoppers                           	| Consumers shopping for major home furnishings.                                                                                                   	| 9.5             	| 62.2        	|
| 6286        	| Luxury Hotel Guests                          	| High income individuals researching and booking hotel rooms.                                                                                     	| 9.3             	| 36.4        	|
| 64          	| High-End Kids Furniture and Clothes Shoppers 	| People shopping at high end childrens clothing and toy retailers.                                                                                	| 8.9             	| 80          	|
| 10977       	| Christmas Celebration Researchers            	| People reading online about Christmas celebration ideas.                                                                                         	| 8.6             	| 121         	|

***

## 👆🏻 D. Index Analysis

The `index_value` is a measure which can be used to reverse calculate the average composition for Fresh Segments’ clients. Average composition can be calculated by dividing the composition column by the index_value column rounded to 2 decimal places.

1. What is the top 10 interests by the average composition for each month?
2. For all of these top 10 interests - which interest appears the most often?
3. What is the average of the average composition for the top 10 interests for each month?
4. What is the 3 month rolling average of the max average composition value from September 2018 to August 2019 and include the previous top ranking interests in the same output shown below.
5. Provide a possible reason why the max average composition might change from month to month? Could it signal something is not quite right with the overall business model for Fresh Segments?

***
