TRUNCATE TABLE posts RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO posts (title, content, views, user_account_id) VALUES ('title1', 'contents1', 45, 1);
INSERT INTO posts (title, content, views, user_account_id) VALUES ('title2', 'content2', 543, 2);