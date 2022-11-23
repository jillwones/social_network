# user_account Model and Repository Classes Design Recipe


## 1. Design and create the Table

```
Table: user_accounts

Columns:
id | username | email_address
```

## 2. Create Test SQL seeds


```sql
-- EXAMPLE
-- (file: spec/seeds_{table_name}.sql)

-- Write your SQL seed here. 

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE user_accounts RESTART IDENTITY CASCADE; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO user_accounts (username, email_address) VALUES ('bob123', 'bob123@gmail.com');
INSERT INTO user_accounts (username, email_address) VALUES ('jill53', 'jill53@hotmail.com');
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
class UserAccount
end

class UserAccountRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
class UserAccount
  attr_accessor :id, :user_name, :email_address
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

class UserAccountRepository
  def all
    # Executes the SQL query:
    # SELECT id, user_name, email_address FROM user_accounts;
    # returns an array of user_account objects
  end 

  def find(id) # id is an int
    # Executes the SQL query:
    # SELECT id, user_name, email_address FROM user_accounts WHERE id = $1;
    # returns single user_account object
  end 

  def create(user_account)
    # inserts a new user_account record
    # Executes the SQL query:
    # INSERT INTO user_accounts (user_name, email_address) VALUES($1, $2);
    # returns nothing
  end

  def delete(id) # id is an int
    # deletes a user_account record
    # Executes the SQL query:
    # DELETE FROM user_accounts WHERE id = $1;
    # returns nothing
  end 
  def update(user_account) 
    # updates a user_account record
    # Executes the SQL query:
    # UPDATE user_accounts SET user_name = $1, email_address = $2 WHERE id = $3;
    # returns nothing
  end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# 1
# gets all user_accounts

repo = UserAccountRepository.new 
all_accounts = repo.all

expect(all_accounts.length).to eq(2)
expect(all_accounts.first.user_name).to eq('jill53')
expect(all_accounts.first.email_address).to eq('jill53@hotmail.com')

# 2
# get a single user_account

repo = UserAccountRepository.new 
user_account = repo.find(1)

expect(user_account.user_name).to eq('jill53')
expect(user_account.email_address).to eq('jill53@hotmail.com')

# 3
# creates a user_account

repo = UserAccountRepository.new
user_account = UserAccount.new

user_account.user_name = 'new user'
user_account.email_address = 'new_email@email.com'

repo.create(user_account)

expect(repo.all.last.user_name).to eq('new user')

# 4 
# deletes a user_account record

repo = UserAccountRepository.new

repo.delete(1)

expect(repo.all.first.id).to eq(2)

# 5 
# updates a user_account record

repo = UserAccountRepository.new
user_account = repo.find(1)
user_account.user_name = 'updated name'
user_account.email_address = 'updated email'

repo.update(user_account)

updated_user = repo.find(1)

expect(updated_user.email_address).to eq('updated email')
expect(updated_user.user_name).to eq('updated name')
```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/student_repository_spec.rb

def reset_user_account_table
  seed_sql = File.read('spec/seeds_user_accounts.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
  connection.exec(seed_sql)
end

describe UserAccountRepository do
  before(:each) do 
    reset_user_account_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._
