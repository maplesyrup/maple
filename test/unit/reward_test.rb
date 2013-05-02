require 'test_helper'

class RewardTest < ActiveSupport::TestCase
  test "basic" do
    assert_equal companies(:apple).campaigns[0].rewards.length, 2, "Not the right number of rewards!"
  end
  
  test "assertions" do
    reward = Reward.new(:title => "hello", :description => "hello again", :campaign_id => 1, :reward => "tits", :quantity => -1, :min_votes => 0)
    assert !reward.save, "Shouldn't be able to save something with negative quantity"

    reward = Reward.new(:title => "hello", :description => "hello again", :campaign_id => 1, :reward => "tits", :quantity => 0, :min_votes => -1)
    assert !reward.save, "Shouldn't be able to save something with negative min_votes"

    reward = Reward.new(:description => "hello again", :campaign_id => 1, :reward => "tits", :quantity => 0, :min_votes => 0)
    assert !reward.save, "Shouldn't be able to save something without a title" 
    
    reward = Reward.new(:title => "hello", :campaign_id => 1, :reward => "tits", :quantity => 0, :min_votes => -1)
    assert !reward.save, "Shouldn't be able to save something without a description"

    reward = Reward.new(:title => "hello", :description => "hello again", :campaign_id => 1, :reward => "tits") 
    assert reward.save, "You should be able to save reward without quantity or min_vote"
  end

  test "decrement quantity" do
    rewards(:one).one_less
    assert_equal rewards(:one).quantity, 0, "failed to decrement rewards"
  end
  
  test "qualifies for?" do
    users(:one).vote_for(posts(:one))
    users(:two).vote_for(posts(:one))
    assert_equal rewards(:one).qualifies_for?(posts(:one)), true, "incorrect qualify"
  end
end
