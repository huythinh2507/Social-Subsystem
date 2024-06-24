# Questions 
**1. What are the popular posts?**

````sql
SELECT p.*, u.name
FROM posts p
JOIN users u ON p.user_id = u.user_id
ORDER BY p.views DESC
LIMIT 5;
````

#### Answer:

| post_id | user_id | content                                             | post_date           | views | likes | shares | comments | name         |
| ------- | ------- | --------------------------------------------------- | ------------------- | ----- | ----- | ------ | -------- | ------------ |
| 4       | 4       | What is love?                                       | 2024-06-11 11:00:00 | 500   | 30    | 20     | 35       | Mentor Four  |
| 3       | 3       | How do we know?                                     | 2024-06-11 11:00:00 | 400   | 20    | 20     | 55       | Mentor Three |
| 7       | 3       | Presenting at the upcoming data science conference. | 2024-06-22 12:00:00 | 350   | 70    | 17     | 22       | Mentor Three |
| 5       | 1       | Just published a new research paper!                | 2024-06-20 10:00:00 | 300   | 60    | 15     | 20       | Mentor One   |
| 8       | 4       | Promoted to Senior HR Manager!                      | 2024-06-23 13:00:00 | 275   | 55    | 13     | 19       | Mentor Four  |

**2. What are the "People to follow"?**

````sql
SELECT u2.user_id, u2.name
FROM user_groups ug1
JOIN user_groups ug2 ON ug1.group_id = ug2.group_id
JOIN users u2 ON ug2.user_id = u2.user_id
WHERE ug1.user_id = 2 AND ug1.user_id != ug2.user_id;
````

#### Answer:

| user_id | name         |
| ------- | ------------ |
| 1       | Mentor One   |
| 3       | Mentor Three |
| 4       | Mentor Four  |
| 6       | Mentee Two   |
| 7       | Mentee Three |

**3. What are the "For You" Feed?**

````sql
SELECT p.*
FROM posts p
JOIN user_groups ug ON p.user_id = ug.user_id
WHERE ug.group_id IN (
  SELECT group_id
  FROM user_groups
  WHERE user_id = 2
)
ORDER BY p.post_date DESC
LIMIT 5;
````

#### Answer:

| post_id | user_id | content                                             | post_date           | views | likes | shares | comments |
| ------- | ------- | --------------------------------------------------- | ------------------- | ----- | ----- | ------ | -------- |
| 11      | 7       | Learned a lot from my first data analysis project.  | 2024-06-26 16:00:00 | 150   | 30    | 7      | 14       |
| 10      | 6       | Attended a great recruiting workshop.               | 2024-06-25 15:00:00 | 125   | 25    | 6      | 12       |
| 8       | 4       | Promoted to Senior HR Manager!                      | 2024-06-23 13:00:00 | 275   | 55    | 13     | 19       |
| 7       | 3       | Presenting at the upcoming data science conference. | 2024-06-22 12:00:00 | 350   | 70    | 17     | 22       |
| 6       | 2       | Hiring for several new roles.                       | 2024-06-21 11:00:00 | 250   | 50    | 12     | 18       |






