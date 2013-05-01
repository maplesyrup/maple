class Reward < ActiveRecord::Base
  attr_accessible :id, :title, :description, :campaign_id,
                  :reward, :quantity, :min_votes

  belongs_to :campaign
  has_and_belongs_to_many :users 
  has_and_belongs_to_many :posts

  validates :title, :presence => true
  validates :description, :presence => true
end
