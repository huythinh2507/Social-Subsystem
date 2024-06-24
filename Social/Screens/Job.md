# Questions 
**1. Query for recommending job?**

````sql
SELECT j.*
FROM Job j
JOIN profiles p ON j.Industry = p.Industry
WHERE p.user_id = 1;
````

#### Answer:
| JobID 	| UserID 	| CompanyName 	| JobTitle          	| Description                                 	| Location    	| PostingDate         	| Industry   	|
|-------	|--------	|-------------	|-------------------	|---------------------------------------------	|-------------	|---------------------	|------------	|
| 1     	| 1      	| TechCorp    	| Software Engineer 	| Develop and maintain software applications. 	| Seattle, WA 	| 2024-06-18 00:00:00 	| Technology 	|
| 7     	| 7      	| CodeWiz     	| Web Developer     	| Design and develop websites.                	| Miami, FL   	| 2024-05-20 00:00:00 	| Technology 	|

**2. How many jobs for you?**

````sql
SELECT COUNT(*) as job4you
FROM Job j
JOIN profiles p ON j.Industry = p.Industry
WHERE p.user_id = 1;
````
| job4you 	|
|-----------|
| 4     	  |
