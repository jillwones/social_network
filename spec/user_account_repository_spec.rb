require 'user_account_repository'

def reset_user_account_table
  seed_sql = File.read('spec/seeds_user_accounts.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
  connection.exec(seed_sql)
end

describe UserAccountRepository do
  before(:each) do 
    reset_user_account_table
  end

  it 'shows all records' do 
    repo = UserAccountRepository.new 
    all_accounts = repo.all

    expect(all_accounts.length).to eq(2)
    expect(all_accounts.first.user_name).to eq('jill53')
    expect(all_accounts.first.email_address).to eq('jill53@hotmail.com')
  end

  it 'gets a single user_account' do 
    repo = UserAccountRepository.new 
    user_account = repo.find(1)

    expect(user_account.user_name).to eq('jill53')
    expect(user_account.email_address).to eq('jill53@hotmail.com')
  end

  it 'gets another single user_account' do 
    repo = UserAccountRepository.new 
    user_account = repo.find(2)

    expect(user_account.user_name).to eq('bob123')
    expect(user_account.email_address).to eq('bob123@gmail.com')
  end

  it 'creates a new record' do 
    repo = UserAccountRepository.new
    user_account = UserAccount.new

    user_account.user_name = 'new user'
    user_account.email_address = 'new_email@email.com'

    repo.create(user_account)

    expect(repo.all.last.user_name).to eq('new user')
  end

  it 'deletes a record' do 
    repo = UserAccountRepository.new

    repo.delete(1)

    expect(repo.all.first.id).to eq('2')
  end

  it 'updates a record' do 
    repo = UserAccountRepository.new
    user_account = repo.find(1)
    user_account.user_name = 'updated name'
    user_account.email_address = 'updated email'

    repo.update(user_account)

    updated_user = repo.find(1)

    expect(updated_user.email_address).to eq('updated email')
    expect(updated_user.user_name).to eq('updated name')
  end
end