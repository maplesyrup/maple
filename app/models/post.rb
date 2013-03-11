class Post < ActiveRecord::Base
  attr_accessible :content, :title, :image, :company_id

  has_attached_file :image, :styles => { :medium => "250x250>", :thumb => "100x100>" }, :default_url => "/images/posts/:style/missing.png"

  belongs_to :user
  belongs_to :company

  acts_as_voteable

  def public_model
    self.to_json(:include => [:user, :company])
  end

  def image_url
    image.url(:medium)
  end

  def profile_image
    if self.user_id
      return "http://graph.facebook.com/" + self.user.uid + "/picture"
    else
      return "http://graph.facebook.com/picture"
    end
  end

  def total_votes
    self.votes_for
  end

  def time_since
    puts "Time Since"
    puts self.created_at
    distance_of_time_in_words_to_now(self.created_at)
  end

  def user_has_voted
    if current_user
      self.voted_by?(current_user)
    end
  end

  def self.public_models(posts)
    posts.to_json({:include => {:user => { :only => [:uid, :email] }, :company => { :only => :name} }, :methods => [:image_url, :total_votes]}).html_safe
  end

  def self.paged_posts(options = {})
    options[:page] ||= 1
    Post.paginate(:page => options[:page], :per_page => 30)
  end

end
