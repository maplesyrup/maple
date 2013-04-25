class Reward < ActiveRecord::Base
  attr_accessible :title, :description, :campaign_id,
                  :swag_award, :monetary_award

  belongs_to :campaign

  validates :title, :presence => true
  validates :description, :presence => true
    
end
