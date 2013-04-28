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
    assert_equal response.length, 1, "incorrect number of campaigns"
  end

   
  # test "the truth" do
  #   assert true
  # end
end
