--trending posts
SELECT 
    p.id AS post_id,
    p.name AS post_name,
    p.content,
    p.created_at,
    p.post_view,
    p.thumbnail_id,
    p.user_id,
    COUNT(l.id) AS total_likes,
    COUNT(s.id) AS total_shares,
    COUNT(c.id) AS total_comments,
    (COUNT(l.id) + COUNT(s.id) + COUNT(c.id)) AS total_reactions
FROM 
    [Post] p
LEFT JOIN 
    [Like] l ON p.id = l.post_id
LEFT JOIN 
    Share s ON p.id = s.post_id
LEFT JOIN 
    Comment c ON p.id = c.post_id
GROUP BY 
    p.id, p.name, p.content, p.created_at, p.post_view, p.thumbnail_id, p.user_id
ORDER BY 
    total_reactions DESC;


--popular post
	SELECT 
    p.name,
    p.content,
    p.thumbnail_id
FROM 
    Post p
ORDER BY 
    p.post_view DESC;

--people to follow
SELECT 
    u.id,
    u.name,
    u.location_id,
    u.jobtitle_id,
    u.role_id,
    u.create_at,
    u.age,
    u.gender,
    u.status,
    u.bio,
    u.profile_pic,
    ui.industry_id,
    i.industry_name
FROM 
    [User] u
JOIN 
    UserIndustry ui ON u.id = ui.user_id
JOIN 
    Industry i ON ui.industry_id = i.id
WHERE 
    ui.industry_id = (SELECT industry_id FROM UserIndustry WHERE user_id = 1)
    AND u.id != 1;

--4u
SELECT 
    p.id AS post_id,
    p.name AS post_name,
    p.content,
    p.created_at,
    p.post_view,
    p.thumbnail_id,
    p.user_id,
    u.name AS user_name,
    ui.industry_id,
    i.industry_name,
    COALESCE(c.comment_count, 0) AS comment_count  -- Use COALESCE to handle NULL values
FROM 
    [Post] p
JOIN 
    [User] u ON p.user_id = u.id
JOIN 
    UserIndustry ui ON u.id = ui.user_id
JOIN 
    Industry i ON ui.industry_id = i.id
LEFT JOIN 
    (SELECT 
         post_id, 
         COUNT(*) AS comment_count 
     FROM 
         Comment 
     GROUP BY 
         post_id
    ) c ON p.id = c.post_id
WHERE 
    ui.industry_id = (SELECT industry_id FROM UserIndustry WHERE user_id = 1)
    AND p.user_id != 1
ORDER BY 
    p.created_at DESC,
    p.post_view DESC;

-- subscribed posts
SELECT 
    p.id AS post_id,
    p.name AS post_name,
    p.content,
    p.created_at,
    p.post_view,
    p.thumbnail_id,
    p.user_id,
    u.name AS user_name,
    ui.industry_id,
    i.industry_name,
    COALESCE(c.comment_count, 0) AS comment_count
FROM 
    UserSubscription us
JOIN 
    [User] u ON us.subscribe_to_id = u.id
JOIN 
    [Post] p ON u.id = p.user_id
JOIN 
    UserIndustry ui ON u.id = ui.user_id
JOIN 
    Industry i ON ui.industry_id = i.id
LEFT JOIN 
    (SELECT 
         post_id, 
         COUNT(*) AS comment_count 
     FROM 
         Comment 
     GROUP BY 
         post_id
    ) c ON p.id = c.post_id
WHERE 
    us.subscriber_id = 1
ORDER BY 
    p.created_at DESC,
    p.post_view DESC

-- readers' choice
SELECT 
    p.id AS post_id,
    p.name AS post_name,
    p.content,
    p.created_at,
    p.post_view,
    p.thumbnail_id,
    p.user_id,
    u.name AS user_name,
    ui.industry_id,
    i.industry_name,
    COALESCE(l.reaction_count, 0) AS like_count,
    COALESCE(c.comment_count, 0) AS comment_count
FROM 
    [Post] p
JOIN 
    [User] u ON p.user_id = u.id
JOIN 
    UserIndustry ui ON u.id = ui.user_id
JOIN 
    Industry i ON ui.industry_id = i.id
LEFT JOIN 
    (SELECT post_id, COUNT(*) AS reaction_count FROM [Like] GROUP BY post_id) l ON p.id = l.post_id
LEFT JOIN 
    (SELECT post_id, COUNT(*) AS comment_count FROM Comment GROUP BY post_id) c ON p.id = c.post_id
WHERE 
    p.created_at >= DATEADD(day, -7, GETDATE())  -- Posts created within the last 7 days
ORDER BY 
    like_count DESC;

-- rising mentor
SELECT
    u.id,
    u.name,
    u.location_id,
    u.jobtitle_id,
    u.role_id,
    u.create_at,
    u.age,
    u.gender,
    u.status,
    u.bio,
    u.profile_pic,
    ui.industry_id,
    i.industry_name,
    COUNT(f.follow_id) AS total_followers
FROM
    [User] u
JOIN
    UserIndustry ui ON u.id = ui.user_id
JOIN
    Industry i ON ui.industry_id = i.id
LEFT JOIN
    Follow f ON u.id = f.followee_id
WHERE
    ui.industry_id = (SELECT industry_id FROM UserIndustry WHERE user_id = 3)  -- Users in the same industry as user with id = 3
    AND u.role_id = 2  -- Users with role_id = 2
    AND u.id != 3  -- Exclude the user with id = 3 from the results
GROUP BY
    u.id, u.name, u.location_id, u.jobtitle_id, u.role_id, u.create_at, u.age, u.gender, u.status, u.bio, u.profile_pic, ui.industry_id, i.industry_name
ORDER BY
    total_followers DESC;

--category
select * from Category;

--connection
SELECT
    c.id AS connection_id,
    c.connector_id,
    u1.name AS connector_name,
    c.receiver_id,
    u2.name AS receiver_name,
    c.connect_date
FROM
    Connection c
JOIN
    [User] u1 ON c.connector_id = u1.id
JOIN
    [User] u2 ON c.receiver_id = u2.id
WHERE
    c.connector_id = 3 OR c.receiver_id = 3;

--people u may know
SELECT DISTINCT
    u.id AS user_id,
    u.name AS user_name,
    u.location_id,
    u.jobtitle_id,
    u.role_id,
    u.create_at,
    u.age,
    u.gender,
    u.status,
    u.bio,
    u.profile_pic
FROM
    [User] u
JOIN
    Post p ON u.id = p.user_id
LEFT JOIN
    [Like] l ON p.id = l.post_id AND l.sender_id = 1
LEFT JOIN
    Share s ON p.id = s.post_id AND s.sender_id = 1
LEFT JOIN
    Comment c ON p.id = c.post_id AND c.sender_id = 1
LEFT JOIN
    Connection con ON con.connector_id = 1 AND con.receiver_id = u.id
WHERE
    (l.sender_id = 1 OR s.sender_id = 1 OR c.sender_id = 1) -- User 1 has liked, shared, or commented on their posts
    AND con.id IS NULL -- User 1 hasn't connected with them yet
    AND u.id != 1; -- Exclude the user with id = 1

--ads
SELECT *
FROM Ads
WHERE GETDATE() >= start_from
  AND GETDATE() <= end_at;



