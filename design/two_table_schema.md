# Two Tables Design Recipe Template

## 1. Extract nouns from the user stories or specification

```
As a social network user,
So I can have my information registered,
I'd like to have a user account with my email address.

As a social network user,
So I can have my information registered,
I'd like to have a user account with my username.

As a social network user,
So I can write on my timeline,
I'd like to create posts associated with my user account.

As a social network user,
So I can write on my timeline,
I'd like each of my posts to have a title and a content.

As a social network user,
So I can know who reads my posts,
I'd like each of my posts to have a number of views.
```

```
Nouns:

user_accounts, username, email_address, posts, title, content, views, user_account_id
```

## 2. Infer the Table Name and Columns

Put the different nouns in this table. Replace the example with your own nouns.

| Record                | Properties          |
| --------------------- | ------------------  |
| user_account          | username, email_address
| post                  | title, content, views, user_account_id

1. Name of the first table (always plural): `user_accounts` 

    Column names: `username`, `email_address`

2. Name of the second table (always plural): `posts` 

    Column names: `title`, `content`, `views`, `user_account_id`

## 3. Decide the column types.

[Here's a full documentation of PostgreSQL data types](https://www.postgresql.org/docs/current/datatype.html).

```
Table: user_accounts
id: SERIAL
username: text
email_address: text

Table: posts
id: SERIAL
title: text
content: text
views: int
user_account_id: int
```

## 4. Decide on The Tables Relationship

Most of the time, you'll be using a **one-to-many** relationship, and will need a **foreign key** on one of the two tables.

To decide on which one, answer these two questions:

1. Can one user_account have many posts? yes
2. Can one post have many user_accounts? no

foreign key in posts table (user_account_id)
```

## 4. Write the SQL.

```sql
CREATE TABLE user_accounts (
  id SERIAL PRIMARY KEY,
  user_name text,
  email_address text
);


CREATE TABLE posts (
  id SERIAL PRIMARY KEY,
  title text,
  content text,
  views int,
-- The foreign key name is always {other_table_singular}_id
  user_account_id int,
  constraint fk_user_account foreign key(user_account_id)
    references user_accounts(id)
    on delete cascade
);

```

## 5. Create the tables.

```bash
psql -h 127.0.0.1 social_network < social_network_tables.sql
```
