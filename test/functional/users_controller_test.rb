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
    # test route
    put :follow, :target => users(:two).id, :type => 'User' 
    assert_response :success, "Follow should have been successful"
   
    # test updated data 
    response = get :show, :id => users(:one).id
    response = JSON.parse(response.body)
    assert_equal response["users_im_following"].length, 1, "incorrect number of follows" 
    assert_equal response["users_following_me"].length, 0, "incorrect number of followed"
    assert_equal response["all_follows"].length, 1, "incorrect number of follows"

    assert_equal response["all_follows"][0]["followable_id"], users(:two).id, "Not following the right person"
    assert_equal response["users_im_following"][0], users(:two).id, "incorrect followed user"
    
    # test followed user

    response = get :show, :id => users(:two).id
    response = JSON.parse(response.body)  
   
    assert_equal response["users_im_following"].length, 0, "incorrect number of follows" 
    assert_equal response["users_following_me"].length, 1, "incorrect number of followed"
    assert_equal response["all_follows"].length, 0, "incorrect number of follows"

    assert_equal response["users_following_me"][0], users(:one).id, "incorrect followed user"
      
  end
  test "should remove follower" do
    put :follow, :target => users(:two).id, :type => 'User' 
    put :follow, :target => users(:two).id, :type => 'User' 
     # test updated data 
    response = get :show, :id => users(:one).id
    response = JSON.parse(response.body)
    assert_equal response["users_im_following"].length, 0, "incorrect number of follows" 
    assert_equal response["users_following_me"].length, 0, "incorrect number of followed"
    assert_equal response["all_follows"].length, 0, "incorrect number of follows"
    
    # test followed user

    response = get :show, :id => users(:two).id
    response = JSON.parse(response.body)  
   
    assert_equal response["users_im_following"].length, 0, "incorrect number of follows" 
    assert_equal response["users_following_me"].length, 0, "incorrect number of followed"
    assert_equal response["all_follows"].length, 0, "incorrect number of follows"
  end
  
  test "shouldn't add a follower" do
    sign_out @userone
    put :follow, :target => users(:two).id, :type => 'User' 
    assert_response 403, "this should have returned 403"
  end  
end
