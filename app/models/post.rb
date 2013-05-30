require 'tire/queries/custom_filters_score'
include ActionView::Helpers::DateHelper

class Post < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks

  # A post has the following fields:
  # id, title, content, created_at,
  # updated_at, user_id, image_file_name,
  # image_content_type, image_file_size,
  # image_updated_at, company_id.

  attr_accessible :content, :title, :image, :company_id, :campaign_id

  has_attached_file :image, :styles => { :large => "400x400>", :medium => "250x250>", :thumb => "100x100>"}, :default_url => "posts/:style/missing.png"

  belongs_to :user
  belongs_to :company
  belongs_to :campaign

  has_and_belongs_to_many :banned_companies, :class_name => "Company", :uniq => true,
      :join_table => "banned_companies_posts"

  acts_as_voteable

  has_many :comments, :as => :commentable
  validates_associated :comments

  has_and_belongs_to_many :rewards

  mapping do
    indexes :_id, index: :not_analyzed
    indexes :title
    indexes :content
    indexes :company_id, type: "integer"
    indexes :user_id, type: "integer"
    indexes :total_votes, type: "integer", index: :not_analyzed
    indexes :created_at, type: "date", index: :not_analyzed
    indexes :last_voted_on, type: "integer", index: :not_analyzed
  end

  module VOTED
    NO = 'no'
    YES = 'yes'
    UNAVAILABLE = 'unavailable'
  end

  GRAVITY = 1.1

  # This is our ranking algorithm. The more votes the post has, the score will go up linearly.
  # The longer the post has been up, the score will go down exponentially. It's based off this
  # site: http://amix.dk/blog/post/19574
  ALGORITHM = "_score *
    ((doc['total_votes'].value + 1) /
    pow(((time() - doc['created_at'].date.getMillis()) / 100000) + 1, #{GRAVITY}))"

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

    post_json = self.as_json(:include => [:company, :user])

    post_json[:full_image_url] = self.image.url
    post_json[:image_url] = self.image.url(:medium)
    post_json[:total_votes] = self.votes_for
    post_json[:voted_on] = self.voted_on(options[:user])
    post_json[:relative_time] = time_ago_in_words(self.created_at)
    post_json[:last_voted_on] = self.votes && self.votes.maximum("created_at").to_i || 0
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

    Jbuilder.encode do |json|
      json.array! posts do |json, post|
        json.(post, :id, :company, :company_id, :content, :created_at, :title)
        json.user do
          json.(post.user, :id, :created_at, :email, :uid, :provider, :name)
          json.avatar_thumb post.user.avatar.url(:thumb)
        end

        if !post.rewards.empty?
          json.rewards post.rewards do |reward|
            json.(reward, :id, :title, :description, :campaign_id, :reward, :quantity, :min_votes)
          end
        end

        if post.campaign
          json.campaign(post.campaign, :id, :title, :description, :starttime, :endtime, :company_id)
        end

        json.full_image_url post.image.url
        json.image_url post.image.url(:medium)
        json.total_votes post.votes_for
        json.voted_on post.voted_on(options[:user])
        json.timestamp post.created_at.to_i
        json.user_id post.user.id if post.user
        json.relative_time time_ago_in_words(post.created_at)
      end
    end
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
        custom_score :script => ALGORITHM do
          string "#{options[:crumb]}:#{options[:query]}", default_operator: 'AND'
        end
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

  def wins(reward)
    self.rewards << reward      
  end

  def has_already_won?(reward)
    self.rewards.include?(reward)
  end
end
