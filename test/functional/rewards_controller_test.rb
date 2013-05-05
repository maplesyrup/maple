require 'test_helper'

class RewardsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  fixtures :all 
 
  test "show" do
    response = get :show, :id => rewards(:one).id   
    response = JSON.parse(response.body) 
    assert_equal response["id"], rewards(:one).id, "didn't get the correct reward"  
  end

  test "update" do
    response = put :update, :id => rewards(:one).id, :reward => {:title => "test"}  
    assert 403, "Shouldn't be able to update a reward if you aren't logged in"
     
    sign_in companies(:apple)
      
    response = put :update, :id => rewards(:three).id, :reward => {:title => "test"}  
    assert 403, "asdfasdfasdf"  

    response = put :update, :id => rewards(:one).id, :reward => {:title => "test"}  
    response = JSON.parse(response.body) 
    assert_equal response["title"], "test", "didn't receive the updated version"

    response = get :show, :id => rewards(:one).id
    response = JSON.parse(response.body)
    assert_equal response["title"], "test", "didn't perpetuate update to reward"
  end
  
  test "index" do
    response = get :index, :campaign_id => campaigns(:one).id 
    response = JSON.parse(response.body)
    assert_equal response.count, 2, "incorrect number of awards" 
  end
  
  test "create" do
    reward = {:title => "herro", :description => "hello again", :campaign_id => 1, :reward => "tits"}  
    
    response = put :create, :campaign_id => campaigns(:one).id, :reward => reward
    assert_response 403, "shouldn't be able to create a reward if you aren't logged in"

    sign_in companies(:apple)

    response = put :create, :campaign_id => campaigns(:two).id, :reward => reward
    assert_response 403, "shouldn't be able to create a reward for another company"

    response = put :create, :campaign_id => campaigns(:one).id, :reward => reward  
    response = JSON.parse(response.body)
    assert_equal response["title"], "herro", "didn't return the correct reward"
    
    response = get :show, :id => response["id"]     
    response = JSON.parse(response.body)
    assert_equal response["title"], "herro", "didn't persist create"
  end
end

