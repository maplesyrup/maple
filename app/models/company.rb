class Company < ActiveRecord::Base

  # A Company has the following fields:
  # id, name, created_at, email,
  # encrypted_password, authentication_token,
  # sign_in_count, current_sign_in_at,
  # last_sign_in_at, current_sign_in_ip,
  # last_sign_in_ip, remember_created_at.

	attr_accessible :splash_image, :blurb_title, :blurb_body, 
      :more_info_title, :more_info_body, :company_url, 
      :email, :password, :password_confirmation, :remember_me, :provider, :logo, :id, :name, :encrypted_password

  has_attached_file :logo, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "posts/:style/missing.png"

	devise :database_authenticatable, :token_authenticatable,
			:registerable, :recoverable,
			:rememberable, :trackable,
			:validatable

	before_save :ensure_authentication_token
  
  has_many :posts

  def self.paged_companies(options = {})
    # self.paged_companies(options):
    # Parameters: "options" - specify "page" number
    # Pass in options[:page] to specify
    # which Companies to retrieve.
    options[:page] ||= 1
    Company.paginate(:page => options[:page], :per_page => 30)
  end

  def public_model(options={})
    # public_model:
    # Convert the instance Company's attributes
    # into JSON.
    Jbuilder.encode do |json|
      json.(self, :id, :name, :splash_image, :blurb_title, :blurb_body, :more_info_title, :more_info_body, :company_url)
      json.logo_urls do
        json.full self.logo.url
        json.medium self.logo.url(:medium)
        json.thumb self.logo.url(:thumb)
      end
      json.editable false
      if options[:company] && options[:company].id == self.id
        json.editable true
      end
    end
  end

  def self.public_models(companies, options={})
    # self.public_models(companies):
    # Parameters: "companies" - array of Companies
    # Pass in an array of Companies and convert
    # them into JSON.
    Jbuilder.encode do |json|
      json.array! companies do |json, company| 
        json.(company, :id, :name, :splash_image, :blurb_title, :blurb_body, :more_info_title, :more_info_body, :company_url)
        json.logo_urls do
          json.full company.logo.url
          json.medium company.logo.url(:medium)
          json.thumb company.logo.url(:thumb)
        end
        json.editable false
        if options[:company] && options[:company].id == company.id
          json.editable true
        end  
      end 
    end
  end
end
