class Post < ActiveRecord::Base
  attr_accessible :content, :title, :image, :company_id

  has_attached_file :image, :styles => { :medium => "250x250>", :thumb => "100x100>" }, :default_url => "/images/posts/:style/missing.png"

  belongs_to :user
  belongs_to :company

  acts_as_voteable

  def public_model
    self.to_json(:include => [:user, :company])
  end

  def self.public_models(posts)
    posts.to_json({:include => {:user => { :only => [:uid, :email] }, :company => { :only => :name} }, :methods => [:image_url, :total_votes]}).html_safe
  end

  def self.paged_posts(options = {})
    options[:page] ||= 1
    Post.paginate(:page => options[:page], :per_page => 30)
  end

end
