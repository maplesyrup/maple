class Post < ActiveRecord::Base

  # A post has the following fields:
  # id, title, content, created_at,
  # updated_at, user_id, image_file_name,
  # image_content_type, image_file_size,
  # image_updated_at, company_id.

  attr_accessible :content, :title, :image, :company_id

  has_attached_file :image, :styles => { :medium => "250x250>", :thumb => "100x100>" }, :default_url => "posts/:style/missing.png"

  belongs_to :user
  belongs_to :company

  acts_as_voteable

  def public_model(options = {})
    # public_model(options):
    # Parameters: "options" - "user" key should be
    # the logged in user
    # Returned JSON includes the author, company,
    # full_image_url, image_url, total_votes,
    # and voted_on
    post_json = self.as_json(:include => [:user, :company])

    post_json[:full_image_url] = self.image.url
    post_json[:image_url] = self.image.url(:medium)
    post_json[:total_votes] = self.votes_for
    post_json[:voted_on] = self.voted_on(options[:user])

    post_json.to_json
  end

  def self.public_models(posts, options = {})
    # self.public_models(posts, options):
    # Parameters: "posts" - Array of posts
    # to convert into JSON, "options" - "user" key
    # should be the logged in user
    # Returned JSON includes the author, company,
    # full_image_url, image_url, total_votes
    # and voted_on
    posts_json = posts.as_json({:include => {:user => { :only => [:uid, :email] }, :company => { :only => :name} }, :methods => [:image_url, :total_votes]})

    posts.each_with_index do |post, idx|
      posts_json[idx][:full_image_url] = post.image.url
      posts_json[idx][:image_url] = post.image.url(:medium)
      posts_json[idx][:total_votes] = post.votes_for
      posts_json[idx][:voted_on] = post.voted_on(options[:user])
    end
    posts_json.to_json
  end

  def self.paged_posts(options = {})
    # self.paged_posts(options):
    # Parameters: "options" - "company" key
    # is the post's associated Company, "page"
    # key sets the page of Posts to retrieve (defaults
    # to 1)
    # Retrieves all of the Posts and includes
    # the associated Company for a Post if
    # it exists.
    # Sorts the results by the number of votes.
    options[:page] ||= 1
    posts = Post.all
    if options[:company_id]
      posts = posts.select do |post|
        options[:company_id].to_i == post.company.id.to_i
      end
    end

    posts.sort { |p1, p2| p2.votes_for <=> p1.votes_for }
  end

  def voted_on(user)
    # voted_on(user):
    # Parameters: "user" - return if the Post
    # has been voted on by the user
    # Return 0 if the user has not voted
    # on the Post
    # Return 1 if the user voted on the Post
    # Return 2 if user is invalid
    if (user)
      if (self.voted_by?(user))
        1
      else
        0
      end
    else
      2
    end
  end

end
