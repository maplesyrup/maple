require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    # Have to delete index before each test
    @user1 = users(:one)
    @user2 = users(:two)
  end

  test "User deletion should give post default user" do

    # Create deleted user
    User.create!(
      :name => 'user_deleted',
      :email => 'nnn@gmail.com',
      :password => 'breakable',
      :password_confirmation => 'breakable')

    post = posts(:one)

    @user1.posts << post
    @user1.save

    User.destroy(@user1.id)

    updated_post = Post.find(post.id)

    assert updated_post.user
    assert updated_post.user.name, 'user_deleted'

  end

end
