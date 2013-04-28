require 'test_helper'

class CampaignTest < ActiveSupport::TestCase
  test "verify basic" do
    assert_equal companies(:apple).campaigns.length, 1, "apple does not have the correct number of campaigns"
    assert_equal campaigns(:microsoft).campaigns.length, 1, "microsoft does not have the correct number of campaigns"
  end
end
