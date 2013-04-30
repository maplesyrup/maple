require 'test_helper'

class RewardTest < ActiveSupport::TestCase
  test "basic" do
    assert_equal companies(:apple).campaigns[0].rewards.length, 2, "Not the right number of rewards!"
  end
end
