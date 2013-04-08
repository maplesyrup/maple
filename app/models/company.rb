# Company Class
# =============
#

#

# 

#

#
class Company < ActiveRecord::Base

  # A Company has the following fields:
  # id, name, created_at, email,
  # encrypted_password, authentication_token,
  # sign_in_count, current_sign_in_at,
  # last_sign_in_at, current_sign_in_ip,
  # last_sign_in_ip, remember_created_at.

	attr_accessible :splash_image, :blurb_title, :blurb_body, 
      :more_info_title, :more_info_body, :company_url, 
      :email, :password, :password_confirmation, :remember_me, :provider, 
      :id, :name, :encrypted_password

	devise :database_authenticatable, :token_authenticatable,
			:registerable, :recoverable,
			:rememberable, :trackable,
			:validatable

	before_save :ensure_authentication_token
  
  has_many :posts

  has_attached_file :splash_image, :default_url => "http://www.hybridlava.com/wp-content/uploads/Wide_wallPAPER011.jpg"  
  
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
        json.editable false
        if options[:company] && options[:company].id == company.id
          json.editable true
        end  
      end 
    end
  end
end
