require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    # Have to delete index before each test
    @user1 = users(:one)
    @user2 = users(:two)
  end

  test "follow with stable data" do

    user = users(:one)
    user.follow(users(:two))
    user.follow(companies(:apple))

    assert_equal users(:two).followers.length, 1, "Incorrect number of followers. Expected 1"
    assert_equal users(:one).follows.length, 2, "Incorrect number of follows. Expected 1"
    assert_equal users(:one).follows_by_type('Company').length, 1, "Incorrect number of company follows"
    assert_equal users(:one).follows_by_type('User').length, 1, "Incorrect number of user follows"

    assert_equal users(:two).followers[0], users(:one), "Follower is not correct"
    assert_equal companies(:apple).followers[0], users(:one), "Follower is not correct"
    assert_equal users(:one).follows[0].followable_id, users(:two).id, "Follows is incorrect"
  end

  test "follow with unstable data" do
    user = users(:one)
    user.follow(users(:one))

    assert_equal users(:one).follows.length, 0, "Users should not be allowed to follow themselves"

    assert_raise StandardError do
      user.follow(companies(:one))
    end
    assert_equal users(:one).follows.length, 0, "User followed company that doesn't exist"

    assert_raise NoMethodError do
      companies(:apple).follow(companies(:microsoft))
    end
  end

  test "unfollow with stable data" do
    user = users(:one)
    user.follow(users(:two))
    user.follow(companies(:apple))
    user.follow(companies(:microsoft))

    user.stop_following(companies(:microsoft))

    user = User.find(user.id) # have to update user after an unfollow

    assert_equal user.follows.length, 2, "incorrect number of follows"
    assert_equal user.follows_by_type('Company').length, 1, "Incorrect number of follows"
    assert_equal user.follows_by_type('User').length, 1, "Incorrect number of follows"
    assert_not_equal user.follows_by_type('Company')[0].followable_id, companies(:microsoft).id, "unfollowed the wrong company"
    assert_equal user.follows_by_type('Company')[0].followable_id, companies(:apple).id, "also deleted apple follows"

    assert_equal companies(:microsoft).followers.length, 0, "Microsoft follower wasn't deleted properly"
    assert_equal companies(:apple).followers.length, 1, "Apple followers has been corrupted"

    user.stop_following(users(:two))

    user = User.find(user.id) #again after unfollow

    assert_equal user.follows.length, 1, "incorrect number of follows"
    assert_equal user.follows_by_type('User').length, 0, "incorrect number of follows for user"
    assert_equal user.follows_by_type('Company').length, 1, "Incorrect number of follows for company"
    assert_equal users(:two).followers.length, 0, "Incorrect number of followers"

  end

  test "unfollow with unstable data" do
    user = users(:one)
    user.stop_following(users(:two))

    user = User.find(user.id)
    assert_equal user.follows.length, 0, "length error"

    user.follow(users(:two))
    user.stop_following(users(:two))
    user.stop_following(users(:two))

    user = User.find(user.id)
    assert_equal user.follows.length, 0, "Double unfollow error"
  end
end
