class Company < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks

  # A Company has the following fields:
  # id, name, created_at, email,
  # encrypted_password, authentication_token,
  # sign_in_count, current_sign_in_at,
  # last_sign_in_at, current_sign_in_ip,
  # last_sign_in_ip, remember_created_at.

	attr_accessible :splash_image, :blurb_title, :blurb_body,
      :more_info_title, :more_info_body, :company_url,
      :email, :password, :password_confirmation, :remember_me, :provider, :id, :name, :encrypted_password, :assets_attributes

  has_attached_file :splash_image, :default_url => "http://www.hybridlava.com/wp-content/uploads/Wide_wallPAPER011.jpg"

	devise :database_authenticatable, :token_authenticatable,
			:registerable, :recoverable,
			:rememberable, :trackable,
			:validatable

	before_save :ensure_authentication_token

  has_many :assets, :as => :attachable
  has_many :posts
  has_many :campaigns

  has_and_belongs_to_many :banned_posts, :class_name => "Post", :uniq => true,
      :join_table => "banned_companies_posts"

  validates_associated :campaigns

  accepts_nested_attributes_for :assets, :allow_destroy => true

  has_many :campaigns
  has_many :comments, :as => :commenter

  validates_associated :comments
  validates_associated :campaigns

  acts_as_followable

  mapping do
    indexes :_id, index: :not_analyzed
    indexes :blurb_title
    indexes :blurb_body
    indexes :more_info_title
    indexes :more_info_body
    indexes :name
    indexes :created_at, type: "date", index: :not_analyzed
    indexes :posts, type: "object", properties: {
      id: { type: "integer" }
    }
  end

  def to_indexed_json
    self.public_model({ :include_posts => true })
  end

  def self.paged_companies(options = {})
    # self.paged_companies(options):
    # Parameters: "options" - specify "page" number
    # Pass in options[:page] to specify
    # which Companies to retrieve.
    options[:page] ||= 1

    # crumb specifies what field in the model you want to search
    options[:crumb] ||= 'name'
    options[:query] ||= '*'

    s = self.search(load: true, page: options[:page], per_page: 30) do
      query do
        string "#{options[:crumb]}:#{options[:query]}", default_operator: 'AND'
      end

      filter :terms, { :id => options[:followed] } if options[:followed].present?

    end
  end

  def public_model(options={})
    # public_model:
    # Convert the instance Company's attributes
    # into JSON.
    Jbuilder.encode do |json|
      json.(self, :id, :name, :splash_image, :blurb_title,
                  :blurb_body, :more_info_title, :more_info_body,
                  :company_url)
      json.logos self.assets do |asset|
        json.(asset, :id, :created_at)
        json.full asset.image.url
        json.medium asset.image.url(:medium)
        json.thumb asset.image.url(:thumb)
        json.selected asset.selected
      end
      json.(self, :posts) if options[:include_posts]
      json.(self, :campaigns) if options[:include_campaigns]
      json.editable false
      if options[:company] && options[:company].id == self.id
        json.editable true
      end
    end
  end

  def current_campaigns
    self.campaigns.select { |campaign| campaign.starttime <= DateTime.now && campaign.endtime > DateTime.now }
  end

  def self.public_models(companies, options={})
    # self.public_models(companies):
    # Parameters: "companies" - array of Companies
    # Pass in an array of Companies and convert
    # them into JSON.
    Jbuilder.encode do |json|
      json.array! companies do |json, company|
        json.(company, :id, :name, :splash_image,
              :blurb_title, :blurb_body, :more_info_title,
              :more_info_body, :company_url)
        json.logos company.assets do |asset|
          json.(asset, :id, :created_at)
          json.full asset.image.url
          json.medium asset.image.url(:medium)
          json.thumb asset.image.url(:thumb)
          json.selected asset.selected
        end
        json.editable false

        if options[:include_current_campaigns]
          json.current_campaigns company.current_campaigns
        end
        if options[:company] && options[:company].id == company.id
          json.editable true
        end
      end
    end
  end
end
