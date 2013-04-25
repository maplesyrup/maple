require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  fixtures :all

  def setup
    @userone = users(:one)
    @usertwo = users(:two)

    sign_in @userone
  end  
  test "should add follower" do
    put :follow, :target => users(:two).id, :type => 'User' 
    assert_response :success, "Follow should have been successful"
    
    get :show, :id => users(:one).id
    assert_equal JSON.parse(response.body)["users_im_following"].length, 1, "incorrect number of follows" 
    assert_equal JSON.parse(response.body)["users_following_me"].length, 0, "incorrect number of followed"

    assert_equal JSON.parse(response.body)["all_follows"].length, 1, "incorrect number of follows"
    
  end
end
