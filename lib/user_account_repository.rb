require_relative './user_account.rb'

class UserAccountRepository
  def all 
    user_accounts = []

    sql = 'SELECT id, user_name, email_address FROM user_accounts;'
    sql_params = []
    result_set = DatabaseConnection.exec_params(sql, sql_params)

    result_set.each do |record|
      user_accounts << record_to_object(record)
    end
    return user_accounts
  end

  def find(id)

    sql = 'SELECT id, user_name, email_address FROM user_accounts WHERE id = $1;'
    sql_params = [id]
    result_set = DatabaseConnection.exec_params(sql, sql_params)

    record = result_set[0]
    record_to_object(record)
  end

  def create(user_account)
    
    sql = 'INSERT INTO user_accounts (user_name, email_address) VALUES($1, $2);'
    sql_params = [user_account.user_name, user_account.email_address]

    result_set = DatabaseConnection.exec_params(sql, sql_params)
  end

  def delete(id)

    sql = 'DELETE FROM user_accounts WHERE id = $1;'
    sql_params = [id]
    result_set = DatabaseConnection.exec_params(sql, sql_params)
  end

  def update(user_account)

    sql = 'UPDATE user_accounts SET user_name = $1, email_address = $2 WHERE id = $3;'
    sql_params = [user_account.user_name, user_account.email_address, user_account.id]
    result_set = DatabaseConnection.exec_params(sql, sql_params)
  end

  private 

  def record_to_object(record)
    user_account = UserAccount.new 

    user_account.id = record['id']
    user_account.user_name = record['user_name']
    user_account.email_address = record['email_address']

    return user_account
  end
end