require 'test_helper'

class RewardTest < ActiveSupport::TestCase
  def setup
    Post.index_name('test_' + Post.model_name.plural)
    Post.index.delete
    Post.create_elasticsearch_index

    @min_vote_1 = posts(:one)
    @min_vote_2 = posts(:two)
    @leader = posts(:leader)
    @leader2 = posts(:leader2)
    @leader3 = posts(:leader3)
    @min_vote_reward = rewards(:one) 
    @top_post_reward = rewards(:four)

    Post.index.import [@min_vote_1, @min_vote_2, @leader, @leader2, @leader3]
    Post.index.refresh
  end
  
  def upvote post, user
    user.vote_for post
    post.save
    Post.index.refresh
    sleep 1 
  end
    
  test "basic" do
    assert_equal companies(:apple).campaigns[0].rewards.count, 2, "Not the right number of rewards!"
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
  
  test "clear winners" do
    assert_equal 0, @top_post_reward.posts.count, "No winners"
    assert_equal 0, @leader.rewards.count, "No rewards"

    @leader.wins @top_post_reward  
    assert_equal 1, @top_post_reward.posts.count, "Should be one winner"
    assert_equal 1, @leader.rewards.count, "Should have one reward"

    @top_post_reward.clear_winners
    assert_equal 0, @top_post_reward.posts.count, "Shouldn't be any winners"
    assert_equal @leader.rewards.count, 0, "shouldn't have any rewards"
  end

end
