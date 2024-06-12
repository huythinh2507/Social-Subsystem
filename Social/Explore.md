# Data sample
**Users Table**
| user_id | email | password | name | location | join_date | role | profile_pic | is_open_to_work |
| ------- | ----- | -------- | ---- | -------- | --------- | ---- | ----------- | --------------- |
| 1 | mentor1@example.com | hashedpassword | Mentor One | Los Angeles | 2024-06-12 08:00:00 | Mentor | profile_pic_mentor1.jpg | TRUE |
| 2 | mentor2@example.com | hashedpassword | Mentor Two | Chicago | 2024-06-13 09:00:00 | Mentor | profile_pic_mentor2.jpg | FALSE |
| 3 | mentor3@example.com | hashedpassword | Mentor Three | Houston | 2024-06-14 10:00:00 | Mentor | profile_pic_mentor3.jpg | TRUE |
| 4 | mentor4@example.com | hashedpassword | Mentor Four | Philadelphia | 2024-06-15 11:00:00 | Mentor | profile_pic_mentor4.jpg | FALSE |
| 5 | mentee1@example.com | hashedpassword | Mentee One | Phoenix | 2024-06-16 12:00:00 | Mentee | profile_pic_mentee1.jpg | TRUE |
| 6 | mentee2@example.com | hashedpassword | Mentee Two | San Antonio | 2024-06-17 13:00:00 | Mentee | profile_pic_mentee2.jpg | FALSE |
| 7 | mentee3@example.com | hashedpassword | Mentee Three | San Diego | 2024-06-18 14:00:00 | Mentee | profile_pic_mentee3.jpg | TRUE |
| 8 | mentee4@example.com | hashedpassword | Mentee Four | Dallas | 2024-06-19 15:00:00 | Mentee | profile_pic_mentee4.jpg | FALSE |

**Profiles Table**
| profile_id | user_id | current_position | skills | experience | education |
| ---------- | ------- | ---------------- | ------ | ---------- | --------- |
| 1 | 1 | Senior Software Developer | JavaScript, Python | 10 years at TechCorp | BSc Computer Science |
| 2 | 2 | HR Manager | Recruiting, Employee Relations | 5 years at HR Inc. | MA Human Resources |

**Posts Table**
| post_id | user_id | content | post_date | views | likes | shares | comments |
| ------- | ------- | ------- | --------- | ----- | ----- | ------ | -------- |
| 1 | 1 | Excited to start my new project! | 2024-06-10 10:00:00 | 150 | 25 | 5 | 10 |
| 2 | 2 | Looking for talented software developers. | 2024-06-11 11:00:00 | 200 | 40 | 10 | 15 |

**PlatformRating Table**
| rating_id | user_id | rating | comment | rating_date |
| --------- | ------- | ------ | ------- | ----------- |
| 1 | 1 | 5 | Great platform! | 2024-06-10 10:00:00 |
| 2 | 2 | 4 | Good experience overall. | 2024-06-11 11:00:00 |

**Tag Table**
| tag_name | usage_count | last_used |
| -------- | ----------- | --------- |
| Software Development | 100 | 2024-06-10 10:00:00 |
| Human Resources | 50 | 2024-06-11 11:00:00 |
| Marketing | 75 | 2024-06-12 14:00:00 |
| Data Science | 120 | 2024-06-13 16:00:00 |
| Machine Learning | 85 | 2024-06-14 15:00:00 |
| Artificial Intelligence | 90 | 2024-06-15 17:00:00 |
| Cybersecurity | 80 | 2024-06-16 18:00:00 |
| Cloud Computing | 95 | 2024-06-17 19:00:00 |
| Web Development | 110 | 2024-06-18 20:00:00 |
| Mobile Development | 105 | 2024-06-19 21:00:00 |

**Challenges Table**
| ChallengeID | UserID | Name | Location | Duration | StartTime |
| ----------- | ------ | ---- | -------- | -------- | --------- |
| 1 | 1 | Catch Rare Pokémon | Viridian Forest | 90min | NOW() + INTERVAL 1 HOUR |
| 2 | 2 | Win Pokémon Contest | Cerulean City | 90min | NOW() + INTERVAL 2 HOUR |
| 3 | 3 | Defeat Elite Four | Indigo Plateau | 90min | NOW() + INTERVAL 3 HOUR |
| 4 | 4 | Complete Pokédex | Pallet Town | 90min | 2024-06-13 16:00:00 |

# Questions 
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
