--trending hashtag
```sql
WITH RecentPosts AS (
    SELECT 
        p.id AS post_id,
        p.created_at
    FROM 
        Post p
    WHERE 
        p.created_at >= DATEADD(day, -7, GETDATE())
),
PostReactions AS (
    SELECT
        p.id AS post_id,
        ISNULL(SUM(l.reaction_count), 0) AS like_count,
        ISNULL(SUM(s.reaction_count), 0) AS share_count,
        ISNULL(SUM(c.reaction_count), 0) AS comment_count
    FROM 
        Post p
    LEFT JOIN 
        [Like] l ON p.id = l.post_id
    LEFT JOIN 
        Share s ON p.id = s.post_id
    LEFT JOIN 
        Comment c ON p.id = c.post_id
    WHERE 
        p.created_at >= DATEADD(day, -7, GETDATE())
    GROUP BY 
        p.id
),
TagReactions AS (
    SELECT 
        tp.tag_id,
        ISNULL(SUM(pr.like_count + pr.share_count + pr.comment_count), 0) AS total_reactions
    FROM 
        TagPost tp
    INNER JOIN 
        PostReactions pr ON tp.post_id = pr.post_id
    GROUP BY 
        tp.tag_id
)
SELECT 
    t.id,
    t.tag_name,
    tr.total_reactions
FROM 
    Tag t
INNER JOIN 
    TagReactions tr ON t.id = tr.tag_id
ORDER BY 
    tr.total_reactions DESC;
```
