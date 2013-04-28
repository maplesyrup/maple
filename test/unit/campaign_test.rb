require 'test_helper'

class CampaignTest < ActiveSupport::TestCase
  test "verify basic" do
    assert_equal companies(:apple).campaigns.length, 1, "apple does not have the correct number of campaigns"
    assert_equal companies(:microsoft).campaigns.length, 1, "microsoft does not have the correct number of campaigns"
  end

  test "verify post relation" do
    assert_equal campaigns(:one).posts.length, 2, "Campaign one doesn't have the appropriate number of associated posts" 
  end 

  test "verify validations" do
    campaign = Campaign.new(:title => "test", :description => "test", :company_id => 1, :starttime => 123 )
    assert !campaign.save, "Able to save without endtime"

    campaign = Campaign.new(:title => "test", :description => "test", :company_id => 1, :endtime => 123 )
    assert !campaign.save, "Able to save without starttime"

    campaign = Campaign.new(:title => "test", :description => "test", :starttime => 123, :endtime => 234 )
    assert !campaign.save, "Able to save without company_id"

    campaign = Campaign.new(:title => "test", :company_id => 1, :starttime => 123, :endtime => 234)
    assert !campaign.save, "Able to save without description"

    campaign = Campaign.new(:description => "test", :company_id => 1, :starttime => 123, :endtime => 234)
    assert !campaign.save, "Able to save without title"

  end
end
