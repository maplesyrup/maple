class UsersController < ApplicationController
  def index
  	# get all users here
  end

  def show
  	# get particular user here
  end

  def check_mobile_login
    print "We are inside check_mobile_login controller"
    token = params[:token]

    user = FbGraph::User.me(token)
    user = user.fetch

    logged_in_user = User.find_by_uid(user.identifier)

    puts logged_in_user

    respond_to do |format|
      format.json { render :json => logged_in_user.authentication_token}
      format.html { render :json => logged_in_user.authentication_token}
    end
  end

end
