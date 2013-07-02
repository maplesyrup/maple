require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  def setup
    # Have to delete index before each test
    Company.index_name('test_' + Company.model_name.plural)
    Company.index.delete
    Company.create_elasticsearch_index

    @apple = companies(:apple)
    @microsoft = companies(:microsoft)
    Company.index.import [@microsoft, @apple]
    Company.index.refresh

    Post.index_name('test_' + Post.model_name.plural)
    Post.index.delete
    Post.create_elasticsearch_index
  end

  def teardown
  end

  test "public model with inclusion of posts" do
    post = posts(:one)

    Post.index.import [post]
    Post.index.refresh

    @apple.posts << post
    c = @apple.public_model({ :include_posts => true })
    response = JSON.parse(c)

    assert response
    assert_equal 1, response['posts'].length
  end

  test "Destroy company should not delete post" do
    post = posts(:one)

    Post.index.import [post]
    Post.index.refresh

    @apple.posts << post

    c = Company.destroy(@apple.id)

    updated_post = Post.find(post.id)

    assert updated_post
    assert !updated_post.company

  end
end
