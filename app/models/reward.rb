class Reward < ActiveRecord::Base
  attr_accessible :id, :title, :description, :campaign_id, :reward, :quantity, :min_votes, :requirement

  belongs_to :campaign

  has_and_belongs_to_many :posts

  validates :quantity, :numericality => { :greater_than_or_equal_to => 0 }, :allow_nil => true
  validates :min_votes, :numericality => { :greater_than_or_equal_to => 0 }, :allow_nil =>true
  validates :title, :presence => true
  validates :description, :presence => true
  
  def self.public_models(rewards)
    Jbuilder.encode do |json|
      json.array! rewards do |json, reward|
        json.(reward, :id, :title, :description, :campaign_id, :reward, :quantity, 
            :min_votes, :requirement)
      end
    end
  end
  
  def public_model
    Jbuilder.encode do |json|
      json.(self, :id, :title, :description, :campaign_id, :reward, :quantity,
            :min_votes, :requirement)
    end
  end 

  def clear_winners
    Reward.find(self.id).posts.delete_all 
    self.save
  end

  def min_vote_winners
    top_posts = self.campaign.top_posts(
      :min_votes => self.min_votes, 
      :campaign_id => self.campaign_id,
    ).results
    top_posts = top_posts.sort_by { |p| Post.find_by_id(p.id.to_i).votes[self.min_votes - 1].created_at }.take(self.quantity)
  end

  def top_post_winners
    top_posts = self.campaign.top_posts(
      :min_votes => self.min_votes, 
      :campaign_id => self.campaign_id,
      :limit => self.quantity
    ).results
  end
  
  def refresh_winners
    winners = []
    case self.requirement
    when "MIN_VOTES"
      winners = self.min_vote_winners
    when "TOP_POST"
      self.clear_winners
      winners = self.top_post_winners  
    end
    winners.each do |winner|
      winner = Post.find_by_id(winner.id)
      winner.wins self unless winner.has_already_won? self
    end
  end
end
