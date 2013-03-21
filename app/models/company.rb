# Company Class
# =============
#
# A Company has the following fields:
# id, name, created_at, email,
# encrypted_password, authentication_token,
# sign_in_count, current_sign_in_at,
# last_sign_in_at, current_sign_in_ip,
# last_sign_in_ip, remember_created_at.
#
# self.paged_companies(options):
# Parameters: "options" - specify "page" number
# Pass in options[:page] to specify
# which Companies to retrieve.
# 
# public_model:
# Convert the instance Company's attributes
# into JSON.
#
# self.public_models(companies):
# Parameters: "companies" - array of Companies
# Pass in an array of Companies and convert
# them into JSON.
#
class Company < ActiveRecord::Base

	attr_accessible :email, :password, :password_confirmation, :remember_me, :provider, :id, :name, :encrypted_password

	devise :database_authenticatable, :token_authenticatable,
			:registerable, :recoverable,
			:rememberable, :trackable,
			:validatable

	before_save :ensure_authentication_token

  def self.paged_companies(options = {})
    options[:page] ||= 1
    Company.paginate(:page => options[:page], :per_page => 30)
  end

  def public_model
    self.to_json
  end

  def self.public_models(companies)
    companies.to_json
  end

end
