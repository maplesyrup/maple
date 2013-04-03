require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test "filtered posts" do
    posts = posts(:one, :two)
    companies = companies(:one, :two)
    posts[0].company = companies[0]
    posts[1].company = companies[1]
    posts.map(&:save)

    filtered_posts = Post.paged_posts({ :company_id => companies[0].id })

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
