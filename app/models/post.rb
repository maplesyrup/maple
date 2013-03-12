class Post < ActiveRecord::Base
  attr_accessible :content, :title, :image, :company_id

  has_attached_file :image, :styles => { :medium => "250x250>", :thumb => "100x100>" }, :default_url => "posts/:style/missing.png"

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
    #TODO sort in SQL query so we can paginate
    posts = Post.all
    if options[:companies]
      posts = posts.select do |post|
        options[:companies].include? post.company.name
      end
    end

    posts.sort { |p1, p2| p2.votes_for <=> p1.votes_for }
  end

end
