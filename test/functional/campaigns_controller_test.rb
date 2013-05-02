require 'test_helper'

class CampaignsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  fixtures :all

  test "company index" do
    response = get :index, :company_id => 1
    response = JSON.parse(response.body)
    assert_equal response.length, 1, "incorrect number of campaigns for Apple"
  end
  
  test "campaign index" do
    response = get :index
    response = JSON.parse(response.body)
    assert_equal response.length, 2, "incorrect number of campaigns"
  end
  
  test "campaign create" do
    response = post :create, :company_id => 1, 
        :campaign => 
          {:title => "test", :description => "Yo yo yo", 
            :starttime => Time.now.utc, :endtime => (Time.now + 120).utc}
    assert_response 403, "Shouldn't be able to create a campaign without being logged in" 
   
    sign_in companies(:apple)
    response = post :create, :company_id => 2, 
        :campaign => 
          {:title => "test", :description => "Yo yo yo", 
            :starttime => Time.now.utc, :endtime => (Time.now + 120).utc}
    assert_response 403, "Shouldn't be able to create a campaign for a company that isn't you" 

    response = post :create, :company_id => 1, 
        :campaign => 
          {:title => "test", :description => "Yo yo yo", 
            :starttime => Time.now.utc, :endtime => (Time.now + 120).utc}
    response = JSON.parse(response.body)       
    assert_equal response["title"], "test", "incorrect response"

    response = get :index, :company_id => 1
    response = JSON.parse(response.body)

    assert_equal response.length, 2, "didn't save the campaiga"
  end

  test "campaign destroy" do
    response = delete :destroy, :id => 1
    assert_response 403, "shouldn't be able to delete a post without being logged in"

    sign_in companies(:apple)
    response = delete :destroy, :id => 2
    assert_response 403, "Shouldn't be able to delete someone elses campaign"

    response = delete :destroy, :id => 1
    response = JSON.parse(response.body)
    assert_equal response["id"], 1, "Didn't delete the correct post"

    response = get :index, :company_id => 1
    response = JSON.parse(response.body)
    assert_equal response.length, 0, "Didn't permanently delete the post"
    sign_out companies(:apple) 
  end

  test "campaign show" do 
    response = get :show, :id => 1
    response = JSON.parse(response.body)
    assert_equal response["id"], campaigns(:one).id, "incorrect campaigns returned on show"   
  end

  test "campaign update" do
    response = put :update, :id => 1
    assert_response 403, "Shouldn't be able to update campaign without login"

    sign_in companies(:apple)
    response = put :update, :id => 2
    assert_response 403, "Shouldn't be able to update another company's campaign"

    response = post :create, :company_id => 1, 
        :campaign => 
          {:title => "test", :description => "Yo yo yo", 
            :starttime => Time.now.utc, :endtime => (Time.now + 120).utc}
    response = JSON.parse(response.body)    
    response = put :update, :id => response["id"], 
      :campaign => 
        {:title => "CompanyOneIsAwesome", :description => "heyo"}
    response = JSON.parse(response.body)
    assert_equal response["title"], "CompanyOneIsAwesome", "Didn't update the post"

    response = get :index, :company_id => 1
    response = JSON.parse(response.body)
    assert_equal response[1]["title"], "CompanyOneIsAwesome", "didn't persist changes in database" 
  end 

  test "rewards index" do
    
  end
end
