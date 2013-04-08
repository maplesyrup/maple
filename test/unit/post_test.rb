require 'test_helper'


class PostTest < ActiveSupport::TestCase
  def setup
    # Have to delete index before each test
    Post.index_name('test_' + Post.model_name.plural)
    Post.index.delete
    Post.create_elasticsearch_index

    @post1 = posts(:one)
    @post2 = posts(:two)

    Post.index.import [@post1, @post2]
    Post.index.refresh
  end

  test "Basic model search" do
    c = Post.paged_posts
    assert_equal 2, c.results.length
  end

  test "sort post by votes" do
    user = users(:one)
    user.vote_for(@post2)
    @post2.save
    Post.index.refresh

    c = Post.paged_posts({
      :sort => {
        :by => 'total_votes',
        :order => 'desc'
      }
    })

    assert_equal 2, c.results.length
    assert_equal @post2.id, c.results[0].id

  end

  test "filtered posts by company id" do
    companies = companies(:apple, :microsoft)
    @post1.company = companies[0]
    @post2.company = companies[1]
    @post1.save
    @post2.save
    Post.index.refresh

    c = Post.paged_posts({ :company_id => companies[0].id })
    filtered_posts = c.results

    assert_equal filtered_posts.length, 1
    assert_equal filtered_posts[0].company.id, companies[0].id

  end

  test "voted on" do
    post = posts(:one)
    users = users(:one, :two)

    users[0].vote_for(post)
    users[0].save

    assert_equal post.voted_on(users[0]), Post::VOTED::YES
    assert_equal post.voted_on(users[1]), Post::VOTED::NO
    assert_equal post.voted_on, Post::VOTED::UNAVAILABLE
  end
end
