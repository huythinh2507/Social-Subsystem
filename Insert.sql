-- Insert data into Jobtitle
INSERT INTO Jobtitle (id, name)
VALUES
('UI/UX Designer'),
('Senior Software Engineer'),
('CEO'),
('Mentor'),
('Data Scientist');

-- Insert data into Location
INSERT INTO Location (name)
VALUES
('Ho Chi Minh'),
('New York'),
('Ha Noi'),
('Chicago');

-- Insert data into User
INSERT INTO [User] (name, asset_id, location_id, jobtitle_id, role_id, create_at, age, gender, status, email, dob, bio, profile_pic) VALUES 
('John Doe', 1, 1, 1, 1, '2024-07-01 08:00:00', 40, 'Male', 1, 'zleffler@example.com', GETDATE(), 'Bio for John Doe', 'profile_john.jpg'),
('Alice Smith', 2, 2, 2, 2, '2024-07-07 08:00:00', 35, 'Female', 1, 'brian59@example.com', GETDATE(), 'Bio for Alice Smith', 'profile_alice.jpg'),
('Bob Johnson', 3, 3, 3, 2, '2024-07-07 08:00:00', 36, 'Male', 1, 'jaquan94@example.com', GETDATE(), 'Bio for Bob Johnson', 'profile_bob.jpg'),
('Carol White', 4, 4, 4, 2, '2024-07-07 08:00:00', 37, 'Female', 1, 'brook64@example.net', GETDATE(), 'Bio for Carol White', 'profile_carol.jpg'),
('David Brown', 5, 1, 5, 2, '2024-07-07 08:00:00', 38, 'Male', 1, 'lynch.daisy@example.com', GETDATE(), 'Bio for David Brown', 'profile_david.jpg'),
('Eve Black', 6, 2, 1, 2, '2024-07-07 08:00:00', 39, 'Female', 1, 'jerome.mccullough@example.com', GETDATE(), 'Bio for Eve Black', 'profile_eve.jpg'),
('Frank Green', 7, 3, 2, 3, '2024-07-07 08:00:00', 20, 'Male', 1, 'eusebio.cartwright@example.org', GETDATE(), 'Bio for Frank Green', 'profile_frank.jpg'),
('Grace Lee', 8, 4, 3, 3, '2024-07-07 08:00:00', 21, 'Female', 1, 'megane42@example.net', GETDATE(), 'Bio for Grace Lee', 'profile_grace.jpg'),
('Hank Martin', 9, 1, 4, 3, '2024-07-07 08:00:00', 22, 'Male', 1, 'tfahey@example.org', GETDATE(), 'Bio for Hank Martin', 'profile_hank.jpg'),
('Ivy Clark', 10, 2, 5, 3, '2024-7-07 08:00:00', 23, 'Female', 1, 'christiansen.nico@example.org', GETDATE(), 'Bio for Ivy Clark', 'profile_ivy.jpg'),
('Jack Walker', 11, 3, 1, 3, '2024-07-07 08:00:00', 24, 'Male', 1, 'ehegmann@example.com', GETDATE(), 'Bio for Jack Walker', 'profile_jack.jpg'),
('Kara Adams', 12, 4, 2, 3, '2024-07-07 08:00:00', 25, 'Female', 1, 'harber.kiera@example.com', GETDATE(), 'Bio for Kara Adams', 'profile_kara.jpg'),
('Liam Young', 13, 1, 3, 3, '2024-07-07 08:00:00', 26, 'Male', 1, 'zaria19@example.org', GETDATE(), 'Bio for Liam Young', 'profile_liam.jpg'),
('Mia King', 14, 2, 4, 3, '2024-07-07 08:00:00', 27, 'Female', 1, 'dion.muller@example.org', GETDATE(), 'Bio for Mia King', 'profile_mia.jpg'),
('Noah Scott', 15, 3, 5, 3, '2024-07-07 08:00:00', 28, 'Male', 1, 'blair54@example.com', GETDATE(), 'Bio for Noah Scott', 'profile_noah.jpg'),
('Olivia Baker', 16, 4, 1, 3, '2024-07-07 08:00:00', 29, 'Female', 1, 'wanda.herman@example.net', GETDATE(), 'Bio for Olivia Baker', 'profile_olivia.jpg'),
('Carol', 9, 1, 4, 3, '2024-07-07 08:00:00', 22, 'Male', 1, 'pmuller@example.com', GETDATE(), 'Bio for Carol', 'profile_carol2.jpg'),
('Martin', 7, 3, 2, 3, '2024-07-07 08:00:00', 20, 'Male', 1, 'aubree.emard@example.org', GETDATE(), 'Bio for Martin', 'profile_martin.jpg'),
('White', 6, 2, 1, 2, '2024-07-07 08:00:00', 39, 'Female', 1, 'sallie.crist@example.com', GETDATE(), 'Bio for White', 'profile_white.jpg');


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
INSERT INTO Tag (tag_name)
VALUES
('Python'),
('Data Science'),
('Selenium'),
('Web Development'),
('React'),
('React Router'),
('Redux'),
('NextJS'),
('React Native'),
('Jupyter Notebook'),
('Machine Learning'),
('Cloud Computing'),
('Cybersecurity'),
('Java'),
('Blockchain'),
('Cryptocurrency'),
('Artificial Intelligence'),
('Project Management'),
('UX Design'),
('Flutter'),
('DevOps');

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
INSERT INTO Challenge (user_id, category_id, challenge_name, description, location, phase, start_date)
VALUES
(1,1, 'Image Classification', 'The challenge is to develop a deep learning model', 'Remote', 'Starting Phase', '2024-06-26'),
(2,1, 'Fraud Detection Kaggle', 'Participate in a Kaggle competition', 'HCM', 'Starting Phase', '2024-06-27'),
(3,5, 'Short Story Writing', 'Writing a compelling short story', 'Remote', 'Starting Phase', '2024-06-23'),
(1,1, 'Data Prediction', 'Predicting data trends using ML', 'Remote', 'Ending Phase', '2024-06-27'),
(2, 5, 'Recipe Development', 'Creating new and innovative recipes', 'Remote', 'Ending Phase', '2024-06-23'),
(1, 1, 'E-commerce Website', 'Develop a full-stack e-commerce website', 'Remote', 'Starting Phase', '2024-07-01'),
(2, 1, 'Sentiment Analysis', 'Analyze sentiment from social media data', 'Remote', 'Starting Phase', '2024-07-01'),
(3, 2, 'Mobile App Design', 'Design a mobile app for a retail store', 'Remote', 'Starting Phase', '2024-07-01'),
(3,3, 'Email Marketing Campaign', 'Create an effective email marketing campaign', 'Remote', 'Starting Phase', '2024-07-01'),
(2,4, 'Personal Finance Blog', 'Write blog posts about personal finance', 'Remote', 'Starting Phase', '2024-07-01'),
(5,5, 'Food Photography', 'Capture high-quality photos of food dishes', 'Remote', 'Starting Phase', '2024-07-01'),
(1,6, 'Short Film Editing', 'Edit a short film with provided footage', 'Remote', 'Starting Phase', '2024-07-01'),
(2,1, 'Real-time Chat Application', 'Build a real-time chat application', 'Remote', 'Starting Phase', '2024-07-01'),
(3,2, 'Landing Page Optimization', 'Optimize the landing page of a website', 'Remote', 'Starting Phase', '2024-07-01'),
(6,5, 'Travel Vlog', 'Create a travel vlog with provided footage', 'Remote', 'Starting Phase', '2024-07-01');
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
  (3, 2, 2, 2, 1, 1),
  (3, 3, 3, 3, 3, 0),
  (4, 4, 4, 4, 4, 1),
  (5, 5, 5, 5, 5, 0);

-- Insert data into University
INSERT INTO University (name, img)
VALUES
('HCMC University of Technology and Education', 'link'),
('Harvard University', 'link'),
('Boston University', 'link');

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
