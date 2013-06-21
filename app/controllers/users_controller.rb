class UsersController < ApplicationController
  def index
  	# get all users here
    options = {}

    users = User.all
    users = params[:type].camelize.constantize.
      find(params[:followable_id]).
      followers if params[:followable_id].present?

    if params[:follower].present?
      users = User.find(params[:follower]).
        follows_by_type('User').
        map(&:followable_id)
      users = User.find(users)
    end
    render :json => User.public_models(users)
  end

  def show
  	# get particular user here
    if current_user && current_user.id == params[:id].to_i
      render :json => current_user.public_model({:user => current_user, :company => current_company})
    else
      render :json => User.find(params[:id]).public_model({:user => current_user, :company => current_company})
    end
  end

  def follow
    target = params[:target]
    type = params[:type]
    if type && target && user_signed_in?
      # parameters exist and user is signed in
      # Convert type to class and find target
      type = type.camelize.constantize
      followed = type.find(target)
      if followed
        # Member of class exists
        if current_user.following?(followed)
          current_user.stop_following(followed)
        else
          current_user.follow(followed)
        end
      end
      render :json => {:following => current_user.follow_count}
    else
      render :json => {}, :status => 403
    end
  end

  def update
    # update user attributes
    @user = User.find(params[:id])
    if current_user && current_user.id == @user.id
      user_params = params[:user]

      attrs_to_update = sanitize(user_params)
      # General attribute update
      @user.update_attributes(attrs_to_update)

      render :json => @user.public_model({:user => current_user, :company => current_company})
    else
      render :json => {}, :status => 403
    end
  end

  def sanitize(model)
    sanitized = {}
    User.attr_accessible[:default].each do |attr|
      sanitized[attr] = model[attr] if model[attr]
    end
    sanitized
  end

  def destroy
    user = User.find_by_id(params[:id])
    '''
    puts "Inside of users_controller.rb destroy"
    user = User.find_by_id(params[:id])
    puts user.inspect
    #user = User.destroy(params[:id])
    user.posts.each do |post|
      puts post.inspect
      puts "Deleting a post index"
      post.index.delete 
    end
    #Post.tire.index.refresh
    '''
    User.find_by_id(params[:id]).destroy
    Post.tire.index.refresh
    puts "After users_controller.rb destroy"

    render :json => user.public_model
  end

  def check_mobile_login
    token = params[:token]

    user = FbGraph::User.me(token)
    user = user.fetch

    unless user
      @user = User.find_for_facebook_oauth(env["omniauth.auth"], current_user)

      if @user.persisted?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
        sign_in_and_redirect @user, :event => :authentication
      else
        session["devise.facebook_data"] = env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
    end

    logged_in_user = User.find_by_uid(user.identifier)

    render :json => logged_in_user.public_model({ :authentication_token => true,
                                                  :email => true })
  end

end
