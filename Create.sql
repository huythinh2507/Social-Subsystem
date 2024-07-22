CREATE TABLE SourceImage (
    id INT PRIMARY KEY IDENTITY(1,1),
    asset_id INT,
    source_id INT,
    source_type_id INT
);

CREATE TABLE Setting (
    id INT PRIMARY KEY,
    setting_type VARCHAR(255),
    setting_name VARCHAR(255),
    setting_value INT
);

CREATE TABLE Jobtitle (
   id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
   name VARCHAR(255)
);

CREATE TABLE Location (
   id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
   name VARCHAR(255)
);

CREATE TABLE Industry (
    id INT PRIMARY KEY,
    industry_name VARCHAR(255),
);

CREATE TABLE UserIndustry (
    industry_id INT,
    user_id INT,
	FOREIGN KEY (industry_id) REFERENCES Industry(id),
	FOREIGN KEY (user_id) REFERENCES [User](id)
);

CREATE TABLE UserSubscription (
    id INT PRIMARY KEY IDENTITY(1,1),
    subscriber_id INT NOT NULL,
    subscribe_to_id INT NOT NULL,
    subscribed_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (subscriber_id) REFERENCES [User](id),
    FOREIGN KEY (subscribe_to_id) REFERENCES [User](id)
);


CREATE TABLE [User] (
   id INT PRIMARY KEY IDENTITY(1,1),
   name VARCHAR(255),
   asset_id INT, -- from the second table
   location_id INT,
   jobtitle_id INT,
   role_id INT,
   create_at DATETIME,
   age INT,
   gender VARCHAR(10),
   status BIT,
   bio VARCHAR(255), -- from the first table
   profile_pic VARCHAR(255), -- from the first table
   email VARCHAR(255), -- from the second table
   dob DATE DEFAULT NULL, -- from the second table
   FOREIGN KEY (jobtitle_id) REFERENCES Jobtitle(id),
   FOREIGN KEY (location_id) REFERENCES Location(id),
   FOREIGN KEY (role_id) REFERENCES Role(id),
);


CREATE TABLE [Post] (
  [id] int PRIMARY KEY,
  [name] nvarchar(255),
  [content] nvarchar(255),
  created_at DATETIME,
  [post_view] int,
  thumbnail_id INT,
  [user_id] INT,
  FOREIGN KEY ([user_id]) REFERENCES [User](id),
  FOREIGN KEY (thumbnail_id) REFERENCES SourceImage(id)
)
CREATE TABLE [Like] (
  id INT IDENTITY(1,1) PRIMARY KEY,
  sender_id INT,
  post_id INT,
  FOREIGN KEY (sender_id) REFERENCES [User](id),
  FOREIGN KEY (post_id) REFERENCES Post([id])
);

-- Share table
CREATE TABLE Share (
  id INT IDENTITY(1,1) PRIMARY KEY,
  sender_id INT,
  post_id INT,
  FOREIGN KEY (sender_id) REFERENCES [User](id),
  FOREIGN KEY (post_id) REFERENCES Post([id])
);

-- Comment table
CREATE TABLE Comment (
  id INT IDENTITY(1,1) PRIMARY KEY,
  sender_id INT,
  post_id INT,
  FOREIGN KEY (sender_id) REFERENCES [User](id),
  FOREIGN KEY (post_id) REFERENCES Post([id])
);

CREATE TABLE Tag (
    id INT PRIMARY KEY IDENTITY(1,1),
    tag_name VARCHAR(255)
);

CREATE TABLE [TagPost] (
  [post_id] int,
  [tag_id] int,
  FOREIGN KEY ([tag_id]) REFERENCES Tag(id),
  FOREIGN KEY (post_id) REFERENCES Post([id])
)

CREATE TABLE Category (
  id INT PRIMARY KEY IDENTITY(1,1),
  name VARCHAR(255)
);

CREATE TABLE Challenge (
    id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT FOREIGN KEY REFERENCES [user](id),
    category_id INT FOREIGN KEY REFERENCES category(id),
    name VARCHAR(255),
    description VARCHAR(255),
    location VARCHAR(255),
    phase VARCHAR(255),
    start_date DATETIME,
    images_id INT,
    FOREIGN KEY (images_id) REFERENCES SourceImage(id)
);

CREATE TABLE Company (
    id INT NOT NULL PRIMARY KEY,
    name VARCHAR(255),
    img VARCHAR(255)
);
CREATE TABLE WorkingType (
	id INT PRIMARY KEY,
	name VARCHAR(255),
)
CREATE TABLE Experience (
    id INT NOT NULL PRIMARY KEY,
    jobtitle_id INT,
    company_id INT,
    type_id INT,
    user_id INT,
    isworking BIT,
    FOREIGN KEY (company_id) REFERENCES Company(id),
    FOREIGN KEY (user_id) REFERENCES [User](id),
    FOREIGN KEY (jobtitle_id) REFERENCES Jobtitle(id),
	FOREIGN KEY (type_id) REFERENCES WorkingType(id)
);

CREATE TABLE University (
    id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(255),
    img VARCHAR(255)
);

CREATE TABLE Education (
    id INT NOT NULL PRIMARY KEY,
    degree VARCHAR(255),
    university_id INT,
    user_id INT,
    FOREIGN KEY (university_id) REFERENCES University(id),
    FOREIGN KEY (user_id) REFERENCES [User](id)
);

CREATE TABLE Skill (
    id INT NOT NULL PRIMARY KEY,
    name VARCHAR(255)
);

CREATE TABLE UserSkill (
    id INT NOT NULL PRIMARY KEY,
    user_id INT,
    skill_id INT,
    FOREIGN KEY (user_id) REFERENCES [User](id),
    FOREIGN KEY (skill_id) REFERENCES Skill(id)
);

CREATE TABLE Follow (
  follow_id INT IDENTITY(1,1) PRIMARY KEY,
  follower_id INT FOREIGN KEY REFERENCES [User](id),
  followee_id INT FOREIGN KEY REFERENCES [User](id),
  follow_date DATETIME DEFAULT (GETUTCDATE())
);

CREATE TABLE Connection (
  id INT IDENTITY(1,1) PRIMARY KEY,
  connector_id INT FOREIGN KEY REFERENCES [User](id),
  receiver_id INT FOREIGN KEY REFERENCES [User](id),
  connect_date DATETIME DEFAULT (GETUTCDATE())
);

-- Create Ads table with url column
CREATE TABLE Ads (
  id INT IDENTITY(1,1) PRIMARY KEY,
  image_id INT,
  title NVARCHAR(255),
  content NVARCHAR(255),
  start_from DATETIME,
  end_at DATETIME,
  url NVARCHAR(255),
  FOREIGN KEY (image_id) REFERENCES SourceImage(id)
);







