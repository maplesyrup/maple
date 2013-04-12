class Post < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks

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

  mapping do
    indexes :_id, index: :not_analyzed
    indexes :title
    indexes :content
    indexes :company_id, type: "integer"
    indexes :user_id, type: "integer"
    indexes :total_votes, type: "integer", index: :not_analyzed
    indexes :created_at, type: "date", index: :not_analyzed
  end

  module VOTED
    NO = 'no'
    YES = 'yes'
    UNAVAILABLE = 'unavailable'
  end

  def to_indexed_json
    self.public_model
  end

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
      posts_json[idx][:timestamp] = post.created_at.to_i
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
    options[:crumb] ||= 'title'
    options[:query] ||= '*'

    s = self.search(load: true, page: options[:page], per_page: 30) do
      query do
        string "#{options[:crumb]}:#{options[:query]}", default_operator: 'AND'
      end

      filter :term, { :company_id => options[:company_id] } if options[:company_id].present?
      filter :term, { :user_id => options[:user_id] } if options[:user_id].present?

      if options[:sort].present?
        sort do
          by options[:sort][:by], (options[:sort][:order] || "desc")
        end
      end
    end
  end

  def voted_on(user = nil)
    return self.voted_by?(user) ? VOTED::YES : VOTED::NO if user

    VOTED::UNAVAILABLE
  end

end
