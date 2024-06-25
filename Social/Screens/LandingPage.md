# Questions 
**1. What is the highest rating of the website?**

````sql
SELECT * FROM platform_rating WHERE rating - (SELECT MAX(rating) FROM platform_rating);
````

#### Answer:
| rating_id | user_id | rating | comment                 | rating_date         |
| --------- | ------- | ------ | ----------------------- | ------------------- |
| 2         | 2       | 4      | Good experience overall | 2024-06-11 11:00:00 |

**2. What are the trending tags of the website?**

````sql
SELECT * FROM tag ORDER BY usage_count DESC LIMIT 5;
````

#### Answer:
| Tag Name | Usage Count |
| -------- | ----------- |
| Data Science | 120 |
| Web Development | 110 |
| Mobile Development | 105 |
| Software Development | 100 |
| Cloud Computing | 95 |

**3. What are the "MENTEE CHOICE" Posts?**

````sql
SELECT * FROM posts ORDER BY likes DESC LIMIT 5;
````

#### Answer:
| post_id | user_id | content | post_date | views | likes | shares | comments |
| ------- | ------- | ------- | --------- | ----- | ----- | ------ | -------- |
| 2 | 2 | Looking for talented software developers. | 2024-06-11 11:00:00 | 200 | 40 | 10 | 15 |
| 4 | 4 | What is love? | 2024-06-11 11:00:00 | 500 | 30 | 20 | 35 |
| 1 | 1 | Excited to start my new project! | 2024-06-10 10:00:00 | 150 | 25 | 5 | 10 |
| 3 | 3 | How do we know? | 2024-06-11 11:00:00 | 400 | 20 | 20 | 55 |

**4. What are the "Upcoming Challenges in 24H"?**

````sql
SELECT *
FROM challenges
WHERE StartTime BETWEEN NOW() AND NOW() + INTERVAL 24 HOUR;
````

#### Answer:
| ChallengeID | UserID | Name | Location | Duration | StartTime |
| ----------- | ------ | ---- | -------- | -------- | --------- |
| 1 | 1 | Catch Rare Pokémon | Viridian Forest | 90min | 2024-06-12 07:20:39 |
| 2 | 2 | Win Pokémon Contest | Cerulean City | 90min | 2024-06-12 08:20:39 |
| 3 | 3 | Defeat Elite Four | Indigo Plateau | 90min | 2024-06-12 09:20:39 |

**5. What are the top 5 most viewed Mentors**

````sql
SELECT u.user_id, u.name, SUM(p.views) AS total_views
FROM users u
JOIN posts p ON u.user_id = p.user_id
WHERE u.role = 'Mentor'
GROUP BY u.user_id, u.name
ORDER BY total_views ASC;
````

#### Answer:
| user_id | name | total_views |
| ------- | ---- | ----------- |
| 1 | Mentor One | 150 |
| 2 | Mentor Two | 200 |
| 3 | Mentor Three | 400 |
| 4 | Mentor Four | 500 |




