require_relative 'lib/database_connection'
require_relative 'lib/post_repository'
require_relative 'lib/user_account_repository'

DatabaseConnection.connect('social_network')

# just playing around with non test database

post_repo = PostRepository.new 
post = post_repo.find(1)
post.views = 999
post_repo.update(post)

user_account_repo = UserAccountRepository.new 
user_account_repo.all.each { |record| p record.user_name }

