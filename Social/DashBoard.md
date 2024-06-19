# Questions 
**1. What are the number of total followers**

````sql
SELECT COUNT(*) AS NumberOfFollowers
FROM follows
WHERE followee_id = 1;
````

#### Answer:

| NumberOfFollowers | 
| ------- | 
| 9       | 

