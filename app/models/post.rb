class Post < ActiveRecord::Base
  attr_accessible :content, :title, :image

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/posts/:style/missing.png"

  belongs_to :user
end
