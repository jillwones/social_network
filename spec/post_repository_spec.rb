require 'post_repository'

def reset_posts_table
  seed_sql = File.read('spec/seeds_posts.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
  connection.exec(seed_sql)
end

describe PostRepository do
  before(:each) do 
    reset_posts_table
  end

  it 'returns all posts' do 
    repo = PostRepository.new 
    all_posts = repo.all

    expect(all_posts.length).to eq(2)
    expect(all_posts.first.title).to eq('title1')
    expect(all_posts.first.views).to eq('45')
  end

  it 'returns a single post' do 
    repo = PostRepository.new 
    post = repo.find(1)

    expect(post.title).to eq('title1')
    expect(post.user_account_id).to eq('1')
  end

  it 'returns another post' do 
    repo = PostRepository.new 
    post = repo.find(2)

    expect(post.title).to eq('title2')
    expect(post.user_account_id).to eq('2')
  end

  it 'creates a new post record' do 
    repo = PostRepository.new
    post = Post.new

    post.title = 'new post'
    post.content = 'content'
    post.views = 0
    post.user_account_id = 2

    repo.create(post)

    expect(repo.all.last.title).to eq('new post')
  end

  it 'deletes a post record' do 
    repo = PostRepository.new 
    post = repo.find(1)
    repo.delete(post.id)

    expect(repo.all.first.id).to eq('2')
  end

  it 'updates a post record' do 
    repo = PostRepository.new
    post = repo.find(1)
    post.title = 'updated title'
    post.content = 'updated content'

    repo.update(post)

    updated_post = repo.find(1)

    expect(updated_post.title).to eq('updated title')
    expect(updated_post.content).to eq('updated content')
  end
end