require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test "filtered posts" do
    posts = posts(:one, :two)
    companies = companies(:one, :two)
    posts[0].company = companies(:one)
    posts[1].company = companies(:two)
    posts.map(&:save)

    filtered_posts = Post.paged_posts({ :companies => ["Apple"] })

    assert_equal filtered_posts.length, 1
    assert_equal filtered_posts[0].company.name, companies(:one).name

  end
end
