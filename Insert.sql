-- Insert data into Jobtitle
INSERT INTO Jobtitle (id, name)
VALUES
  (1, 'Software Engineer'),
  (2, 'Data Analyst'),
  (3, 'UI/UX Designer'),
  (4, 'HR Manager'),
  (5, 'Marketing Specialist');

-- Insert data into Location
INSERT INTO Location (id, name)
VALUES
  (1, 'New York'),
  (2, 'San Francisco'),
  (3, 'London'),
  (4, 'Tokyo'),
  (5, 'Sydney');

-- Insert data into User
INSERT INTO [User] (id, name, location_id, jobtitle_id, role_id, create_at, age, gender, status, bio, profile_pic)
VALUES
  (1, 'John Doe', 1, 1, 1, '2024-07-11 12:00:00', 30, 'Male', 1, 'Software Engineer with 5+ years experience', 'https://example.com/profile_pic1'),
  (2, 'Jane Smith', 2, 2, 2, '2024-07-10 12:00:00', 28, 'Female', 1, 'Data Analyst specializing in Python and SQL', 'https://example.com/profile_pic2'),
  (3, 'Michael Johnson', 3, 3, 3, '2024-07-09 12:00:00', 35, 'Male', 1, 'Experienced UI/UX Designer with a focus on Adobe XD', 'https://example.com/profile_pic3'),
  (4, 'Emily Brown', 4, 4, 4, '2024-07-08 12:00:00', 32, 'Female', 1, 'HR Manager with expertise in recruitment and employee relations', 'https://example.com/profile_pic4'),
  (5, 'David Wilson', 5, 5, 5, '2024-07-07 12:00:00', 29, 'Male', 1, 'Marketing Specialist with 6+ years in digital marketing', 'https://example.com/profile_pic5');

-- Insert data into Image
INSERT INTO Image (image_url)
VALUES
  ('https://example.com/image1'),
  ('https://example.com/image2'),
  ('https://example.com/image3'),
  ('https://example.com/image4'),
  ('https://example.com/image5');

-- Insert data into Post
INSERT INTO Post (id, name, content, created_at, post_view, thumbnail_id, user_id)
VALUES
  (1, 'Post 1', 'Content of Post 1', '2024-07-11 12:00:00', 1412450, 1, 1),
  (2, 'Post 2', 'Content of Post 2', '2024-07-10 12:00:00', 11112321, 2, 2),
  (3, 'Post 3', 'Content of Post 3', '2024-07-09 12:00:00', 213124, 3, 3),
  (4, 'Post 4', 'Content of Post 4', '2024-07-08 12:00:00', 21312, 4, 4),
  (5, 'Post 5', 'Content of Post 5', '2024-07-07 12:00:00', 12124124, 5, 5);

-- Insert data into ImagePost
INSERT INTO ImagePost (post_id, image_id)
VALUES
  (1, 1),
  (2, 2),
  (3, 3),
  (4, 4),
  (5, 5);

-- Insert data into Like
INSERT INTO [Like] (sender_id, post_id)
VALUES
  (1, 1),
  (2, 2),
  (3, 3),
  (4, 4),
  (5, 5);

-- Insert data into Share
INSERT INTO Share (sender_id, post_id)
VALUES
  (1, 1),
  (2, 2),
  (3, 3),
  (4, 4),
  (5, 5);

-- Insert data into Comment
INSERT INTO Comment (sender_id, post_id)
VALUES
  (1, 1),
  (2, 2),
  (3, 3),
  (4, 4),
  (5, 5);

-- Insert data into Tag
INSERT INTO Tag (id, tag_name)
VALUES
  (1, 'Tag 1'),
  (2, 'Tag 2'),
  (3, 'Tag 3'),
  (4, 'Tag 4'),
  (5, 'Tag 5');

-- Insert data into TagPost
INSERT INTO TagPost (post_id, tag_id)
VALUES
  (1, 1),
  (2, 2),
  (3, 3),
  (4, 4),
  (5, 5);

-- Insert data into Category
INSERT INTO Category (name)
VALUES
('Information Technology'),
('UI/UX Design'),
('Marketing'),
('Lifestyle'),
('Photography'),
('Video');

-- Insert data into Challenge
INSERT INTO Challenge (id, user_id, category_id, challenge_name, description, location, phase, start_date)
VALUES
  (1, 1, 1, 'Challenge 1', 'Description for Challenge 1', 'Location for Challenge 1', 'Phase 1', '2024-07-11'),
  (2, 2, 2, 'Challenge 2', 'Description for Challenge 2', 'Location for Challenge 2', 'Phase 2', '2024-07-10'),
  (3, 3, 3, 'Challenge 3', 'Description for Challenge 3', 'Location for Challenge 3', 'Phase 3', '2024-07-09'),
  (4, 4, 4, 'Challenge 4', 'Description for Challenge 4', 'Location for Challenge 4', 'Phase 4', '2024-07-08'),
  (5, 5, 5, 'Challenge 5', 'Description for Challenge 5', 'Location for Challenge 5', 'Phase 5', '2024-07-07');
-- Insert data into Company
INSERT INTO Company (id, name, img)
VALUES
  (1, 'Company A', 'https://example.com/company_a_logo'),
  (2, 'Company B', 'https://example.com/company_b_logo'),
  (3, 'Company C', 'https://example.com/company_c_logo'),
  (4, 'Company D', 'https://example.com/company_d_logo'),
  (5, 'Company E', 'https://example.com/company_e_logo');

-- Insert data into WorkingType
INSERT INTO WorkingType (id, name)
VALUES
  (1, 'Full-time'),
  (2, 'Part-time'),
  (3, 'Contract'),
  (4, 'Freelance'),
  (5, 'Internship');

-- Insert data into Experience
INSERT INTO Experience (id, jobtitle_id, company_id, type_id, user_id, isworking)
VALUES
  (1, 1, 1, 1, 1, 1),
  (2, 2, 2, 2, 2, 1),
  (3, 3, 3, 3, 3, 0),
  (4, 4, 4, 4, 4, 1),
  (5, 5, 5, 5, 5, 0);

-- Insert data into University
INSERT INTO University (id, name, img)
VALUES
  (1, 'University A', 'https://example.com/university_a_logo'),
  (2, 'University B', 'https://example.com/university_b_logo'),
  (3, 'University C', 'https://example.com/university_c_logo'),
  (4, 'University D', 'https://example.com/university_d_logo'),
  (5, 'University E', 'https://example.com/university_e_logo');

-- Insert data into Education
INSERT INTO Education (id, degree, university_id, user_id)
VALUES
  (1, 'Bachelor of Science', 1, 1),
  (2, 'Master of Business Administration', 2, 2),
  (3, 'Bachelor of Arts', 3, 3),
  (4, 'Master of Science', 4, 4),
  (5, 'Bachelor of Engineering', 5, 5);

-- Insert data into Skill
INSERT INTO Skill (id, name)
VALUES
  (1, 'Java'),
  (2, 'Python'),
  (3, 'SQL'),
  (4, 'JavaScript'),
  (5, 'HTML/CSS');

-- Insert data into UserSkill
INSERT INTO UserSkill (id, user_id, skill_id)
VALUES
  (1, 1, 1),
  (2, 2, 2),
  (3, 3, 3),
  (4, 4, 4),
  (5, 5, 5);

INSERT INTO Follow (follower_id, followee_id, follow_date)
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

INSERT INTO Connection (connector_id, receiver_id, connect_date)
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


INSERT INTO Ads (image_id, title, content, start_from, end_at, url)
VALUES
  (1, 'Summer Sale', 'Huge discounts on summer clothing!', '2024-07-01 00:00:00', '2024-07-31 23:59:59', 'http://example.com/summer-sale'),
  (2, 'Back to School', 'Get ready for the new school year with our supplies!', '2024-08-01 00:00:00', '2024-08-31 23:59:59', 'http://example.com/back-to-school'),
  (3, 'Winter Collection', 'New winter collection is now available!', '2024-09-01 00:00:00', '2024-09-30 23:59:59', 'http://example.com/winter-collection'),
  (4, 'Black Friday Deals', 'Unbeatable prices on Black Friday!', '2024-11-01 00:00:00', '2024-11-30 23:59:59', 'http://example.com/black-friday-deals'),
  (5, 'Holiday Specials', 'Special offers for the holiday season!', '2024-12-01 00:00:00', '2024-12-31 23:59:59', 'http://example.com/holiday-specials');
