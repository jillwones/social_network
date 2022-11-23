# post Model and Repository Classes Design Recipe


## 1. Design and create the Table

```
Table: posts

Columns:
id | title | contents | views | user_account_id
```

## 2. Create Test SQL seeds


```sql
-- EXAMPLE
-- (file: spec/seeds_{table_name}.sql)

-- Write your SQL seed here. 

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE posts RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO posts (title, contents, views, user_account_id) VALUES ('title1', 'contents1', 45, 1);
INSERT INTO posts (title, contents, views, user_account_id) VALUES ('title2', 'content2', 543, 2);
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
class Post
end

class PostRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
class Post
  attr_accessor :id, :title, :content, :views, :user_account_id
end
```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: students

# Repository class
# (in lib/student_repository.rb)

class PostRepository
  def all
    # Executes the SQL query:
    # SELECT id, title, content, views, user_account_id FROM posts;
    # returns an array of post objects
  end 

  def find(id) # id is an int
    # Executes the SQL query:
    # SELECT id, title, content, views, user_account_id FROM posts WHERE id = $1;
    # returns single post object
  end 

  def create(post)
    # inserts a new post record
    # Executes the SQL query:
    # INSERT INTO posts (title, content, views, user_account_id) VALUES($1, $2, $3, $4);
    # returns nothing
  end

  def delete(id) # id is an int
    # deletes a post record
    # Executes the SQL query:
    # DELETE FROM posts WHERE id = $1;
    # returns nothing
  end 

  def update(post) 
    # updates a post record
    # Executes the SQL query:
    # UPDATE posts SET title = $1, content = $2, views = $3, user_account_id = $4 WHERE id = $5;
    # returns nothing
  end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# 1
# gets all posts

repo = PostRepository.new 
all_posts = repo.all

expect(all_posts.length).to eq(2)
expect(all_posts.first.title).to eq('title1')
expect(all_posts.first.views).to eq('45')

# 2
# get a single post

repo = PostRepository.new 
post = repo.find(1)

expect(post.title).to eq('title1')
expect(post.user_account_id).to eq('1')

# 3
# creates a post

repo = PostRepository.new
post = Post.new

post.title = 'new post'
post.content = 'content'
post.views = 0
post.user_account_id = 2

repo.create(post)

expect(repo.all.last.title).to eq('new post')

# 4 
# deletes a post record

repo = PostRepository.new

repo.delete(1)

expect(repo.all.first.id).to eq(2)

# 5 
# updates a post record

repo = PostRepository.new
post = repo.find(1)
post.title = 'updated title'
post.content = 'updated content'

repo.update(post)

updated_post = repo.find(1)

expect(updated_post.title).to eq('updated title')
expect(updated_post.content).to eq('updated content')

```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/student_repository_spec.rb

def reset_posts_table
  seed_sql = File.read('spec/seeds_posts.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
  connection.exec(seed_sql)
end

describe PostRepository do
  before(:each) do 
    reset_posts_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._
