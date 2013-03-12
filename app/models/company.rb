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
end
