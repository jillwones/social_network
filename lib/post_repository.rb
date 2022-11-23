require_relative './post.rb'

class PostRepository
  def all 
    posts = []

    sql = 'SELECT id, title, content, views, user_account_id FROM posts;'
    sql_params = []
    result_set = DatabaseConnection.exec_params(sql, sql_params)

    result_set.each do |record|
      posts << record_to_object(record)
    end
    return posts
  end

  def find(id)

    sql = 'SELECT id, title, content, views, user_account_id FROM posts WHERE id = $1;'
    sql_params = [id]
    result_set = DatabaseConnection.exec_params(sql, sql_params)

    record = result_set[0]

    return record_to_object(record)
  end

  def create(post)

    sql = 'INSERT INTO posts (title, content, views, user_account_id) VALUES($1, $2, $3, $4);'
    sql_params = [post.title, post.content, post.views, post.user_account_id]
    result_set = DatabaseConnection.exec_params(sql, sql_params)
  end

  def delete(id)

    sql = 'DELETE FROM posts WHERE id = $1'
    sql_params = [id]
    result_set = DatabaseConnection.exec_params(sql, sql_params)
  end

  def update(post)

    sql = 'UPDATE posts SET title = $1, content = $2, views = $3, user_account_id = $4 WHERE id = $5;'
    sql_params = [post.title, post.content, post.views, post.user_account_id, post.id]
    result_set = DatabaseConnection.exec_params(sql, sql_params)
  end

  private

  def record_to_object(record)
    post = Post.new
    post.id = record['id']
    post.title = record['title']
    post.content = record['content']
    post.views = record['views']
    post.user_account_id = record['user_account_id']

    return post
  end
end