class Campaign < ActiveRecord::Base
  attr_accessible :title, :description, :starttime, :endtime,
                  :company_id
  
  belongs_to :company
  has_many :rewards

  validates :starttime, :presence => true
  validates :title, :presence => true
  validates :description, :presence => true
   
  validates :endtime, :presence => true
  validates_associated :rewards
        
end
