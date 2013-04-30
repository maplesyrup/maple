class TimeValidator < ActiveModel::Validator
  def validate(record)
    if record.starttime.nil? || record.endtime.nil?
      record.errors[:base] << "Times aren't allowed to be empty"  
    else
      if record.starttime.utc < 2.minutes.ago.utc
        # Validator give 2 min leeway to record verification in the event 
        # of a slow connection 
        record.errors[:base] << "Not allowed to start a campaign in the past" 
      end
      if record.endtime.utc <= record.starttime.utc
        record.errors[:base] << "Not allowed to end before you start"
      end 
    end
  end
end

class Campaign < ActiveRecord::Base
  attr_accessible :title, :description, :starttime, :endtime,
                  :company_id
 
  belongs_to :company, :dependent => :destroy
  has_many :rewards
  has_many :posts

  validates :starttime, :presence => true
  validates :title, :presence => true
  validates :description, :presence => true
  
  validates_with TimeValidator, :field => [:starttime, :endttime]

  validates :company_id, :presence => true

  validates :endtime, :presence => true
  
  validates_associated :rewards
  validates_associated :posts
  

  
  def self.public_models(campaigns, options={})
    Jbuilder.encode do |json|
      json.array! campaigns do |json, campaign|
        json.(campaign, :id, :title, :description, :starttime, :endtime, :company_id)
      end
    end
  end

  def public_model(options={})
    Jbuilder.encode do |json|
      json.(self, :id, :title, :description, :starttime, :endtime, :company_id)
    end
  end
end  
