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
  
  test "min vote winners" do
    assert_equal 0, @min_vote_reward.min_vote_winners.count, "Nothing should exist here"
    upvote @min_vote_1, users(:one)
    assert_equal 0, @min_vote_reward.min_vote_winners.count, "User doesn't have enough votes to win yet"
    
    upvote @min_vote_1, users(:two)
    winners = @min_vote_reward.min_vote_winners
    assert_equal 1, winners.count, "User one should win"
    assert_equal @min_vote_1.id, winners[0].id.to_i, "User one should be the winner"
    
    upvote @min_vote_2, users(:one)
    upvote @min_vote_2, users(:two)
    winners = @min_vote_reward.min_vote_winners
    assert_equal @min_vote_reward.quantity, winners.count, "Out of rewards! ermagehr"
    assert_equal @min_vote_1.id, winners[0].id.to_i, "User one should still be the winner"
    
    upvote @min_vote_2, users(:commenter)
    winners = @min_vote_reward.min_vote_winners
    assert_equal @min_vote_reward.quantity, winners.count
    assert_equal @min_vote_1.id, winners[0].id.to_i, "No matter how many upvotes user 2 gets, user one should never lose becuase he got to the minimum number of votes first"
  end 
  
  test "top post winners" do
    assert_equal 0, @top_post_reward.top_post_winners.count, "Nothing should exist here"
   
    upvote @leader, users(:one) 
    assert_equal 0, @top_post_reward.top_post_winners.count, "Not enough points to qualify yet" 
    
    upvote @leader, users(:two)
    assert_equal 1, @top_post_reward.top_post_winners.count, "Post should have won"
    
    upvote @leader2, users(:one)
    upvote @leader2, users(:two)
    winners = @top_post_reward.top_post_winners
    assert_equal 2, winners.count, "Should be two winners right now"
    assert_equal @leader.id, winners[0].id.to_i, "post one should be in the lead. Same points but post one's last vote was before post two's last vote"
    
    upvote @leader3, users(:one)
    upvote @leader3, users(:two)
    winners = @top_post_reward.top_post_winners
    assert_equal @top_post_reward.quantity, winners.count, "Should be two winners right now"
    assert_equal @leader.id, winners[0].id.to_i, "post one should still be in first"
    assert_equal @leader2.id, winners[1].id.to_i, "post two should still be in second"
    
    upvote @leader3, users(:commenter)
    winners = @top_post_reward.top_post_winners
    assert_equal @top_post_reward.quantity, winners.count, "Should be two winners still"
    assert_equal @leader3.id, winners[0].id.to_i, "post three should now be in first because he has the most upvotes"
    assert_equal @leader.id, winners[1].id.to_i, "post 1 should now be in second because he has the second most upvotes and the earliest votes"
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

  test "refresh winners" do
    @top_post_reward.refresh_winners  
    assert_equal 0, @top_post_reward.posts.count, "No winners yet" 
    assert_equal 0, @leader.rewards.count
    assert_equal 0, @leader2.rewards.count 
    assert_equal 0, @leader3.rewards.count 
     
    upvote @leader, users(:one)
    @top_post_reward.refresh_winners
    assert_equal 0, @top_post_reward.posts.count, "No winners yet" 
    assert_equal 0, @leader.rewards.count
    assert_equal 0, @leader2.rewards.count 
    assert_equal 0, @leader3.rewards.count 
    
    upvote @leader, users(:two) 
    @top_post_reward.refresh_winners
    assert_equal 1, @top_post_reward.posts.count, "Should be one winner" 
    assert_equal 1, @leader.rewards.count
    assert_equal 0, @leader2.rewards.count 
    assert_equal 0, @leader3.rewards.count 

    upvote @leader2, users(:one) 
    upvote @leader2, users(:two)
    @top_post_reward.refresh_winners
    assert_equal @top_post_reward.quantity, @top_post_reward.posts.count, "Should be two winners" 
    assert_equal 1, @leader.rewards.count
    assert_equal 1, @leader2.rewards.count 
    assert_equal 0, @leader3.rewards.count 

    upvote @leader3, users(:one) 
    upvote @leader3, users(:two)
    @top_post_reward.refresh_winners
    assert_equal @top_post_reward.quantity, @top_post_reward.posts.count, "Should be two winners" 
    assert_equal 1, @leader.rewards.count
    assert_equal 1, @leader2.rewards.count 
    assert_equal 0, @leader3.rewards.count, "Leader three still should have won an award"

    upvote @leader3, users(:commenter) 
    @top_post_reward.refresh_winners
    assert_equal @top_post_reward.quantity, @top_post_reward.posts.count, "Should be two winners" 
    assert_equal 1, @leader.rewards.count
    assert_equal 0, @leader2.rewards.count, "Leader two should lose their award"
    assert_equal 1, @leader3.rewards.count 
  end
end
