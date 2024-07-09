
-- Create the user table
CREATE TABLE [user] (
  id INT IDENTITY(1,1) PRIMARY KEY,
  email NVARCHAR(255) NOT NULL,
  password NVARCHAR(255) NOT NULL,
  name NVARCHAR(255) NOT NULL,
  location NVARCHAR(255),
  join_date DATETIME DEFAULT (GETUTCDATE()),
  role NVARCHAR(50),
  profile_pic NTEXT,
  is_open_to_work BIT,
  phone_number NVARCHAR(255),
  current_position NVARCHAR(255),
  skills NTEXT,
  experience NTEXT,
  education NTEXT,
  industry_id INT,
  age INT,
  gender NVARCHAR(10),
  country NVARCHAR(10)
);

-- Insert sample data
INSERT INTO [user] (email, password, name, location, role, profile_pic, is_open_to_work, phone_number, current_position, skills, experience, education, industry_id)
VALUES
  ('user1@example.com', 'password1', 'John Doe', 'Seattle', 'Developer', 'profile1.jpg', 1, '123-456-7890', 'Software Engineer', 'Java, Python', '3 years at Company X', 'BS in Computer Science', 1),
  ('user2@example.com', 'password2', 'Jane Smith', 'New York', 'Designer', 'profile2.jpg', 0, '987-654-3210', 'UI/UX Designer', 'Photoshop, Sketch', 'Freelancer', 'BFA in Graphic Design', 1),
  ('user3@example.com', 'password3', 'Alice Brown', 'Chicago', 'Data Analyst', 'profile3.jpg', 1, '555-789-1234', 'Data Science', 'R, SQL', '2 years at Data Co.', 'MS in Statistics', 1),
  ('user4@example.com', 'password4', 'Bob Johnson', 'Los Angeles', 'Product Manager', 'profile4.jpg', 1, '111-222-3333', 'Product Strategy', 'Agile, Scrum', '5 years at Product Corp.', 'MBA', 2),
  ('user5@example.com', 'password5', 'Eva Lee', 'San Francisco', 'Marketing Specialist', 'profile5.jpg', 0, '444-555-6666', 'Digital Marketing', 'SEO, SEM', 'Marketing Agency', 'BA in Marketing', 3);

-- Update age and gender for specific users
UPDATE [user]
SET age = 30, gender = 'Male'
WHERE id = 1;

UPDATE [user]
SET age = 28, gender = 'Female'
WHERE id = 2;

UPDATE [user]
SET age = 25, gender = 'Female'
WHERE id = 3;

UPDATE [user]
SET age = 35, gender = 'Male'
WHERE id = 4;

UPDATE [user]
SET age = 27, gender = 'Female'
WHERE id = 5;

-- Update country for specific users
UPDATE [user]
SET country = 'Vietnam'
WHERE id IN (1, 3);

UPDATE [user]
SET country = 'USA'
WHERE id IN (2, 4, 5);


CREATE TABLE post (
  post_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  name NVARCHAR(255),
  content NVARCHAR(MAX),
  post_date DATETIME,
  views INT NOT NULL,
  likes INT,
  shares INT,
  comments INT,
  display_image NVARCHAR(MAX),
  FOREIGN KEY (user_id) REFERENCES [user]
);

INSERT INTO post (user_id, name, content, post_date, views, likes, shares, comments, display_image)
VALUES
(1, 'Post 1', 'Post content 1', GETUTCDATE(), 1400, 201, 52, 118, 'post1.jpg'),
(2, 'Post 2', 'Post content 2', GETUTCDATE(), 5120, 10, 24, 33, 'post2.jpg'),
(3, 'Post 2', 'Post content 2', GETUTCDATE(), 5120, 10, 24, 33, 'post2.jpg'),
(4, 'Post 2', 'Post content 2', GETUTCDATE(), 5120, 10, 24, 33, 'post2.jpg'),
(5, 'Post 10', 'Post content 10', GETUTCDATE(), 800, 50, 15, 22, 'post10.jpg');

CREATE TABLE mentor (
id INT IDENTITY(1,1) PRIMARY KEY,
  profile_views INT,
  user_id INT FOREIGN KEY REFERENCES [user](id)
);

INSERT INTO mentor (profile_views, user_id)
VALUES
  (1111, 1),
  (341, 3),
  (444, 2),
  (777, 4),
  (1234, 5);

CREATE TABLE [like] (
  id INT IDENTITY(1,1) PRIMARY KEY,
  sender_id INT FOREIGN KEY REFERENCES [user](id),
  post_id INT FOREIGN KEY REFERENCES post(post_id),
  reaction_count INT DEFAULT (0)
);

INSERT INTO [like] (sender_id, post_id, reaction_count)
VALUES
  (2, 1, 5),
  (2, 1, 3);

  
  CREATE TABLE share (
  id INT IDENTITY(1,1) PRIMARY KEY,
  sender_id INT FOREIGN KEY REFERENCES [user](id),
  post_id INT FOREIGN KEY REFERENCES post(post_id),
  reaction_count INT DEFAULT (0)
);

INSERT INTO share (sender_id, post_id, reaction_count)
VALUES
  (3, 1, 1),
  (3, 1, 1);



  CREATE TABLE comment (
  id INT IDENTITY(1,1) PRIMARY KEY,
  sender_id INT FOREIGN KEY REFERENCES [user](id),
  post_id INT FOREIGN KEY REFERENCES post(post_id),
  reaction_count INT DEFAULT (0)
);

INSERT INTO comment (sender_id, post_id, reaction_count)
VALUES
  (2, 1, 4),
  (3, 1, 2);

  DROP TABLE platform_rating;
  CREATE TABLE platform_rating (
  rating_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT FOREIGN KEY REFERENCES [user](id),
  rating INT,
  comment NTEXT,
  rating_date DATETIME DEFAULT (GETUTCDATE())
);

INSERT INTO platform_rating (user_id, rating, comment, rating_date)
VALUES
  (1, 5, 'Great platform!', GETUTCDATE()),
  (2, 4, 'Good experience', GETUTCDATE()),
  -- Add more rows as needed
  (3, 3, 'Needs improvement', GETUTCDATE());



  CREATE TABLE challenge (
  ChallengeID INT IDENTITY(1,1) PRIMARY KEY,
  UserID INT FOREIGN KEY REFERENCES [user](id),
  Name NVARCHAR(255),
  Location NVARCHAR(255),
  Duration NVARCHAR(255),
  StartTime DATETIME DEFAULT (GETUTCDATE()),
  Category NVARCHAR(255),
  Description NTEXT,
  Phase NVARCHAR(255),
  Thumbnail NVARCHAR(255)  -- Changed data type to NVARCHAR for text
);

INSERT INTO challenge (UserID, Name, Location, Duration, StartTime, Category, Description, Phase, Thumbnail)
VALUES
  (1, 'Coding Challenge', 'Online', '1 week', GETUTCDATE(), 'Programming', 'Solve algorithm problems', 'Phase 1', 'p1.jpg'),
  (2, 'Design Challenge', 'New York', '2 days', GETUTCDATE(), 'UI/UX', 'Create a mobile app design', 'Phase 2', 'p2.jpg'),
  (3, 'Data Analysis Challenge', 'Remote', '3 weeks', GETUTCDATE(), 'Data Science', 'Analyze a real-world dataset', 'Phase 1', 'p3.jpg'),
  (4, 'Marketing Strategy Challenge', 'Online', '1 month', GETUTCDATE(), 'Marketing', 'Develop a marketing plan for a new product', 'Phase 2', 'p4.jpg'),
  (5, 'Web Development Challenge', 'Global', '2 weeks', GETUTCDATE(), 'Web Development', 'Build a simple web application', 'Phase 1', 'p5.jpg'),
  (1, 'Machine Learning Challenge (Advanced)', 'Online', '2 months', GETUTCDATE(), 'Machine Learning', 'Build a machine learning model for image classification', 'Phase 2', 'p6.jpg'),
  (2, 'UI/UX Challenge for E-commerce', 'Remote', '1 week', GETUTCDATE(), 'UI/UX', 'Design a user-friendly e-commerce platform', 'Phase 1', 'p7.jpg'),
  (4, 'Product Management Challenge', 'Online', '1 month', GETUTCDATE(), 'Product Management', 'Develop a product roadmap for a startup', 'Phase 2', 'p8.jpg'),
  (3, 'Data Visualization Challenge', 'Global', '2 weeks', GETUTCDATE(), 'Data Science', 'Create compelling data visualizations', 'Phase 1', 'p9.jpg'),
  (5, 'Content Marketing Challenge', 'Online', '1 month', GETUTCDATE(), 'Marketing', 'Develop a content marketing strategy for a specific niche', 'Phase 2', 'p10.jpg');

  CREATE TABLE [group] (
  group_id INT IDENTITY(1,1) PRIMARY KEY,
  group_name NVARCHAR(255),
  description NTEXT
);

INSERT INTO [group] (group_name, description)
VALUES
  ('Developers', 'A group for software developers'),
  ('Designers', 'A group for creative designers');


  CREATE TABLE user_group (
user_id INT FOREIGN KEY REFERENCES [user](id),
  group_id INT FOREIGN KEY REFERENCES [group](group_id),
  join_date DATETIME DEFAULT (GETUTCDATE())
);

INSERT INTO user_group (user_id, group_id, join_date)
VALUES
  (1, 1, GETUTCDATE()), -- John joins Developers Club
  (2, 2, GETUTCDATE()) -- Jane joins Design Enthusiasts
  -- Add more user group data here
;

CREATE TABLE activity (
  activity_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT FOREIGN KEY REFERENCES [user](id),
  activity_name NVARCHAR(255),
  activity_date DATETIME DEFAULT (GETUTCDATE()),
  target_id INT FOREIGN KEY REFERENCES [user](id)
);

INSERT INTO activity (user_id, activity_name, activity_date, target_id)
VALUES
  (1, 'like', GETUTCDATE(), 2),
  (1, 'share', GETUTCDATE(), 2),
  (1, 'comment', GETUTCDATE(), 2),
  (2, 'share', GETUTCDATE(), 3)
  -- Add more activity data here
;

CREATE TABLE follow (
  follow_id INT IDENTITY(1,1) PRIMARY KEY,
  follower_id INT FOREIGN KEY REFERENCES [user](id),
  followee_id INT FOREIGN KEY REFERENCES [user](id),
  follow_date DATETIME DEFAULT (GETUTCDATE())
);

INSERT INTO follow (follower_id, followee_id, follow_date)
VALUES
  --user 1
  (2, 1, GETUTCDATE()),
  (3, 1, GETUTCDATE()),
  (4, 1, GETUTCDATE()),
  (5, 1, GETUTCDATE()),
  --user 2
  (1, 2, GETUTCDATE()),
  (4, 2, GETUTCDATE()),
  (5, 2, GETUTCDATE()),
  --user 3
  (1, 3, GETUTCDATE()),
  (2, 3, GETUTCDATE());


CREATE TABLE sub (
  id INT IDENTITY(1,1) PRIMARY KEY,
  subcriber_id INT FOREIGN KEY REFERENCES [user](id),
  publisher_id INT FOREIGN KEY REFERENCES [user](id),
  sub_date DATETIME DEFAULT (GETUTCDATE())
);

INSERT INTO sub (subcriber_id, publisher_id, sub_date)
VALUES
  --user 1
  (2, 1, GETUTCDATE()),
  (3, 1, GETUTCDATE()),
  (4, 1, GETUTCDATE()),
  (5, 1, GETUTCDATE()),
  --user 2
  (1, 2, GETUTCDATE()),
  (4, 2, GETUTCDATE()),
  (5, 2, GETUTCDATE()),
  --user 3
  (1, 3, GETUTCDATE()),
  (2, 3, GETUTCDATE());


CREATE TABLE connection (
  id INT IDENTITY(1,1) PRIMARY KEY,
  connector_id INT FOREIGN KEY REFERENCES [user](id),
  receiver_id INT FOREIGN KEY REFERENCES [user](id),
  connect_date DATETIME DEFAULT (GETUTCDATE())
);
INSERT INTO connection (connector_id, receiver_id, connect_date)
VALUES
  --user 3
  (1, 3, GETUTCDATE()),
  (2, 3, GETUTCDATE()),
  --user 4
  (1, 4, GETUTCDATE()),
  (2, 4, GETUTCDATE()),
  (3, 4, GETUTCDATE()),
  --user 5
  (1, 5, GETUTCDATE()),
  (2, 5, GETUTCDATE()),
  (3, 5, GETUTCDATE());

  CREATE TABLE network (
  id INT PRIMARY KEY,
  user_id INT,
  number_of_connections INT,
  number_of_follows INT,
  number_of_group INT,
  number_of_event INT,
  number_of_newsletter INT,
  number_of_hashtag INT,
  number_of_program INT,
  number_of_mentor INT,
  FOREIGN KEY (user_id) REFERENCES [user](id)
);

INSERT INTO network (id, user_id, number_of_connections, number_of_follows, number_of_group, number_of_event, number_of_newsletter, number_of_hashtag, number_of_program, number_of_mentor)
VALUES
  (1, 1, 1400, 201, 52, 118, 1, 2, 3, 7);

  CREATE TABLE event (
  ID INT PRIMARY KEY,
  user_id INT REFERENCES [user],
  Name VARCHAR(255),
  Price VARCHAR(50),
  Location VARCHAR(255),
  Date DATETIME2, -- Use DATETIME2 instead of TIMESTAMP
  PostDate DATETIME2, -- Use DATETIME2 for specific date and time
  Image VARCHAR(50),
  Category VARCHAR(50),
  Type VARCHAR(50),
  Language VARCHAR(50),
  Duration VARCHAR(50),
  TicketType VARCHAR(50),
  FOREIGN KEY (user_id) REFERENCES [user]
);

-- Inserting sample events
INSERT INTO event (ID, user_id, Name, Price, Location, Date, PostDate, Image, Category, Type, Language, Duration, TicketType)
VALUES
  (1, 1, 'Tech Conference', 'Free', 'Seattle', '2024-06-30 10:00:00', SYSDATETIME(), NULL, 'Technology', 'Conference', 'English', '2 days', 'General Admission'),
  (2, 1, 'Workshop', 'Paid', 'Seattle', '2024-07-01 14:30:00', SYSDATETIME(), NULL, 'Technology', 'Workshop', 'English', '4 hours', 'VIP Pass'),
  (3, 2, 'Networking Event', 'Free', 'Seattle', '2024-07-02 18:00:00', SYSDATETIME(), NULL, 'Networking', 'Event', 'English', '3 hours', 'General Admission');


  
CREATE TABLE job (
  JobID INT IDENTITY(1,1) PRIMARY KEY,
  UserID INT,
  CompanyName VARCHAR(255),
  JobTitle VARCHAR(255),
  Description TEXT,
  Location VARCHAR(255),
  PostingDate DATETIME2, 
  Industry VARCHAR(255),
  FOREIGN KEY (UserID) REFERENCES [user](id)
);
INSERT INTO job (UserID, CompanyName, JobTitle, Description, Location, PostingDate, Industry)
VALUES
  (1, 'TechCorp', 'Software Engineer', 'Full-stack development', 'Seattle, WA', SYSDATETIME(), 'Technology'),
  (2, 'DesignCo', 'UI/UX Designer', 'Create stunning interfaces', 'New York, NY', SYSDATETIME(), 'Design')
;

ALTER TABLE [user] DROP COLUMN Industry;

CREATE TABLE industry (
    id INT PRIMARY KEY,
    industry_name VARCHAR(255),
);

INSERT INTO industry (id, industry_name)
VALUES
(1, 'Tech'),
(2, 'Business'),
(3, 'Marketing'),
(4, 'Finance'),
(5, 'Healthcare'),
(6, 'Education'),
(7, 'Retail'),
(8, 'Manufacturing'),
(9, 'Hospitality'),
(10, 'Transportation'),
(11, 'Entertainment'),
(12, 'Energy'),
(13, 'Telecommunications');

CREATE TABLE user_industry (
    industry_id INT,
    user_id INT,
	FOREIGN KEY (industry_id) REFERENCES industry(id),
	FOREIGN KEY (user_id) REFERENCES [user](id)
);

INSERT INTO user_industry (industry_id, user_id)
VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 4),
(3, 5);

CREATE TABLE tag (
  tag_id INT IDENTITY(1,1) PRIMARY KEY,
  tag_name NVARCHAR(255),
  usage_count_in7day INT,
  first_used DATETIME DEFAULT (GETUTCDATE()),
  last_used DATETIME DEFAULT (GETUTCDATE()),
  industry_id  INT REFERENCES industry(id)
);

INSERT INTO tag (tag_name, usage_count_in7day, first_used, last_used, industry_id)
VALUES
  ('#programming', 111110, '2024-07-03', GETUTCDATE(), 1),
  ('#database', 2131235, '2024-07-03', GETUTCDATE(), 1),
  ('#web', 123218, '2024-07-03', GETUTCDATE(), 1),
  ('#cloud', 98765, '2024-07-03', GETUTCDATE(), 1),
  ('#security', 54321, '2024-07-03', GETUTCDATE(), 1),
  ('#frontend', 67890, '2024-07-03', GETUTCDATE(), 1),
  ('#backend', 45678, '2024-07-03', GETUTCDATE(), 1),
  ('#mobile', 23456, '2024-07-03', GETUTCDATE(), 1),
  ('#data-science', 78901, '2024-07-03', GETUTCDATE(), 1),
  ('#devops', 34567, '2024-07-03', GETUTCDATE(), 1);

CREATE TABLE post_tag (tag_id INT, post_id INT);

INSERT INTO post_tag (tag_id, post_id)
VALUES
  (1, 1),
  (2, 1),
  (3, 1),
  (5, 1),
  (4, 1),
  (7, 1),
  (1, 2),
  (2, 2),
  (3, 2),
  (4, 2),
  (1, 3),
  (2, 3);

  CREATE TABLE daily_tag_usage (
  tag_id INT,
  date DATE,
  daily_usage_count INT,
  PRIMARY KEY (tag_id, date)
);

-- Example data for daily_tag_usage
INSERT INTO daily_tag_usage (tag_id, date, daily_usage_count)
VALUES
  (1, '2024-07-03', 100), -- #programming
  (2, '2024-07-03', 200), -- #database
  (3, '2024-07-03', 50),  -- #web
  (10, '2024-07-03', 30); -- #devops