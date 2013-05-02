class Reward < ActiveRecord::Base
  attr_accessible :id, :title, :description, :campaign_id,
                  :reward, :quantity, :min_votes

  belongs_to :campaign
  has_and_belongs_to_many :users 
  has_and_belongs_to_many :posts

  validates :quantity, :numericality => { :greater_than_or_equal_to => 0 }, :allow_nil => true
  validates :min_votes, :numericality => { :greater_than_or_equal_to => 0 }, :allow_nil =>true
  validates :title, :presence => true
  validates :description, :presence => true

  def self.public_models(rewards)
    Jbuilder.encode do |json|
      json.array! rewards do |json, reward|
        json.(reward, :id, :title, :description, :campaign_id, :reward, :quantity, 
            :min_votes)
      end
    end
  end
  
  def public_model
    Jbuilder.encode do |json|
      json.(self, :id, :title, :description, :campaign_id, :reward, :quantity,
            :min_votes)
    end
  end 
  
  def one_less 
    quantity = self.quantity - 1 
    self.update_attributes(:quantity => quantity)
  end

  def qualifies_for?(post)
    # This doesn't seem thread safe
    if self.min_votes <= post.plusminus && self.quantity && self.quantity > 0 
      true 
    else
      false
    end
  end
end
