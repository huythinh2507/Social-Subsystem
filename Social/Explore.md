**1. What are the "Reader's Choice" Posts?**

````sql
SELECT * FROM posts ORDER BY likes DESC LIMIT 5;
````

#### Answer:

| post_id | user_id | content                                             | post_date           | views | likes | shares | comments |
| ------- | ------- | --------------------------------------------------- | ------------------- | ----- | ----- | ------ | -------- |
| 7       | 3       | Presenting at the upcoming data science conference. | 2024-06-22 12:00:00 | 350   | 70    | 17     | 22       |
| 5       | 1       | Just published a new research paper!                | 2024-06-20 10:00:00 | 300   | 60    | 15     | 20       |
| 8       | 4       | Promoted to Senior HR Manager!                      | 2024-06-23 13:00:00 | 275   | 55    | 13     | 19       |
| 6       | 2       | Hiring for several new roles.                       | 2024-06-21 11:00:00 | 250   | 50    | 12     | 18       |
| 2       | 2       | Looking for talented software developers.           | 2024-06-11 11:00:00 | 200   | 40    | 10     | 15       |
