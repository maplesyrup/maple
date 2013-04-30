class Reward < ActiveRecord::Base
  attr_accessible :id, :title, :description, :campaign_id,
                  :swag_award, :monetary_reward

  belongs_to :campaign
  has_and_belongs_to_many :users 

  validates :title, :presence => true
  validates :description, :presence => true

end
