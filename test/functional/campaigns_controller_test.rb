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
            :starttime => Time.new, :endtime => Time.new}
   
    require 'pry'
    binding.pry

    response = JSON.parse(response.body)       
    assert_equal response["title"], "test", "incorrect response"

    response = get :index, :company_id => 1
    response = JSON.parse(response.body)

    assert_equal response.length, 2, "didn't save the campaiga"
  end 
end
