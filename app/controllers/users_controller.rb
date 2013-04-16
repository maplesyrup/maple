class UsersController < ApplicationController
  def index
  	# get all users here
  end

  def show
  	# get particular user here
    if current_user && current_user.id == params[:id].to_i
      render :json => current_user.public_model({:user => current_user, :company => current_company})
    else 
      render :json => User.find(params[:id]).public_model({:user => current_user, :company => current_company})
    end  
  end

  def update
    # update user attributes  
    @user = User.find(params[:id])
    if current_user && current_user.id == @user.id

      if params[:relation]
        # Relationship update 
        if params[:relation][:begin]
          if params[:relation][:begin][:user]
            user_to_follow = User.find(params[:relation][:begin][:user])
            current_user.follow(user_to_follow)
          elsif params[:relation][:begin][:company]
            company_to_follow = Company.find(params[:relation][:begin][:company])
            current_user.follow(company_to_follow)
          end 
        elsif params[:relation][:end]
          if params[:relation][:end][:user]
            user_stop_following = User.find(params[:relation][:end][:user])
            current_user.stop_following(user_stop_following) 
          elsif params[:relation][:end][:company] 
            company_stop_following = Company.find(params[:relation][:end][:company]) 
            current_user.stop_following(company_stop_following)
          end
        end
      end

      attrs_to_update = sanitize(params[:user])
      # General attribute update
      if attrs_to_update.length > 2 
        @user.update_attributes(attrs_to_update)
      else
        @user.update_attribute(attrs_to_update.keys[0], attrs_to_update.values[0])
      end
      
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

  def check_mobile_login
    token = params[:token]

    user = FbGraph::User.me(token)
    user = user.fetch

    logged_in_user = User.find_by_uid(user.identifier)

    respond_to do |format|
      format.json { render :json => logged_in_user.authentication_token}
      format.html { render :json => logged_in_user.authentication_token}
    end
  end

end
