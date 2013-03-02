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

  end
end
