class Asset < ActiveRecord::Base
  belongs_to :attachable, :polymorphic => true

  attr_accessible :image, :selected

  has_attached_file :image, :styles => { :thumb => "100x100", :medium => "300x300" }, :default_url => "posts/:style/missing.png"
end
