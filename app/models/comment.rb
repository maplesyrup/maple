class Comment < ActiveRecord::Base
  attr_accessible :content
  
  belongs_to :commentable, :polymorphic => true
  belongs_to :commenter, :polymorphic => true
   
  has_many :comments, :as => :commentable
  
  acts_as_voteable    

  validates_associated :comments
  validates :commentable_id, :commentable_type, :presence => true
  validates :content, :presence =>true    
end
