class PostsController < ApplicationController

  def create
    user = User.find(params["user_id"])

    post = Post.new()
    post.image = params["image"]

    user.posts << post
    post.user = user

    post.save
    user.save
  end

  def index
    if user_signed_in?
      @logged_in_user = current_user
    end

  end
end
