class Campaign < ActiveRecord::Base
  attr_accessible :title, :description, :starttime, :endtime,
                  :company_id
  
  belongs_to :company
  has_many :rewards
  has_many :posts

  validates :starttime, :presence => true
  validates :title, :presence => true
  validates :description, :presence => true
  
  validates :company_id, :presence => true

  validates :endtime, :presence => true
  
  validates_associated :rewards
  validates_associated :posts
  
  def self.public_models(campaigns, options={})
    Jbuilder.encode do |json|
      json.array! campaigns do |json, campaign|
        json.(campaign, :title, :description, :starttime, :endtime, :company_id)
      end
    end
  end

  def public_model(options={})
    Jbuilder.encode do |json|
      json.(self, :title, :description, :starttime, :endtime, :company_id)
    end
  end

end
