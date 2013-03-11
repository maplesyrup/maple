class Company < ActiveRecord::Base

	attr_accessible :email, :password, :password_confirmation, :remember_me, :provider, :id, :name

	devise :database_authenticatable, :token_authenticatable, 
			:registerable, :recoverable, 
			:rememberable, :trackable, 
			:validatable

	before_save :ensure_authentication_token
end
