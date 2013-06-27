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
