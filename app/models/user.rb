class User < ActiveRecord::Base
  # A user has the following fields:
  # "id", "email", "encrypted_password",
  # "reset_password_token", "reset_password_sent_at",
  # "remember_created_at", "sign_in_count",
  # "current_sign_in_at", "last_sign_in_at",
  # "current_sign_in_ip", "last_sign_in_ip",
  # "created_at", "updated_at", "avatar_file_name",
  # "avatar_content_type", "avatar_file_size",
  # "avatar_updated_at", "provider", "uid", "name",
  # "authentication_token", "type"

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :token_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  before_save :ensure_authentication_token

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation,
                  :remember_me, :provider, :uid, :name,
                  :personal_info, :avatar, :authentication_token

  has_many :posts

  has_many :comments, :as => :commenter
  validates_associated :comments

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "50x50", :header_thumb => "25x25" }, :default_url => "avatars/:style/missing.png"

  acts_as_voter
  acts_as_followable
  acts_as_follower

  validates :name, :uniqueness => true

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    # self.find_for_facebook_oauth(auth,
    # signed_in_resource):
    # Parameters: "auth" - Facebook authenticated
    # user information
    # Retrive the User that matches the authenticated
    # Facebook user or add a new User to the database
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(name:auth.extra.raw_info.name,
                           provider:auth.provider,
                           uid:auth.uid,
                           email:auth.info.email,
                           password:Devise.friendly_token[0,20])
    end
    user
  end


  def self.new_with_session(params, session)
    # self.new_with_session(params, session):
    # Parameters: "params" - extra parameters,
    # "session" -
    # Use the session's Facebook email as the User's
    # email if the User does not have an email
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.public_models(users, options={})
    Jbuilder.encode do |json|
      json.array! users do |json, user|

        company_follows = user.follows_by_type('Company')
        user_follows = user.follows_by_type('User')
        users_following = user.following_by_type('User')

        json.(user, :id, :name, :created_at, :avatar, :personal_info, :all_follows)
        json.avatar_thumb user.avatar.url(:thumb)
        json.(user, :posts) if options[:include_posts]
        json.editable false
        if options[:user] && options[:user].id == user.id
          json.editable true
        end
      end
    end
  end

  def public_model(options={})
    # public_model:
    # Convert the instance User's attributes
    # into JSON.
    company_follows = self.follows_by_type('Company')
    user_follows = self.follows_by_type('User')
    users_following = self.followers_by_type('User')

    Jbuilder.encode do |json|
      json.(self, :id, :name, :created_at, :avatar, :personal_info, :all_follows)
      json.(self, :posts) if options[:include_posts]
      json.(self, :authentication_token) if options[:authentication_token]
      json.(self, :email) if options[:email]
      json.companies_im_following company_follows.map{|company| company.followable_id}
      json.users_im_following user_follows.map{|user| user.followable_id}
      json.users_following_me users_following.map{|user| user.id}
      json.avatar_thumb avatar.url(:thumb)
      json.editable false
      if options[:user] && options[:user].id == self.id
        json.editable true
      end
    end
  end
  
  def rewards
    users_rewards = [] 
    self.posts.each do |post|
      post.rewards.each do |reward|
        users_rewards << reward
      end
    end
    users_rewards
  end

end
