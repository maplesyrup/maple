class Comment < ActiveRecord::Base
  attr_accessible :id, :content, :commentable_id, :commentable_type,
                  :commenter_id, :commenter_type
  
  belongs_to :commentable, :polymorphic => true
  belongs_to :commenter, :polymorphic => true
   
  has_many :comments, :as => :commentable
  
  acts_as_voteable    

  validates_associated :comments
  validates :commentable_id, :commentable_type, :presence => true
  validates :commenter_id, :commenter_type, :presence => true
  validates :content, :presence =>true    

   
  def public_model
    Jbuilder.encode do |json|
      json.(self, :id, :content, :commentable_id, :commenter_id, :commenter_type)
      json.commenter_name self.commenter.name if self.commenter.name
      json.avatar_thumb self.commenter.avatar.url(:thumb) if self.commenter.avatar
    end 
  end

  def self.public_models(comments, options = {})
    Jbuilder.encode do |json|
      json.array! comments do |json, comment|  
        json.(comment, :id, :content, :commentable_id, :commenter_id, :commenter_type)
        json.commenter_name comment.commenter.name if comment.commenter.name
        json.avatar_thumb comment.commenter.avatar.url(:thumb) if comment.commenter.avatar
      end
    end
  end
end
