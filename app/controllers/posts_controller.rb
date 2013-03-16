class PostsController < ApplicationController

  def create
    if params[:token]
      user = FbGraph::User.me(params[:token])
      user = user.fetch
      logged_in_user = User.find_by_uid(user.identifier)
      sign_in(:user, logged_in_user)
      params[:post].delete :token
    end

    post = params[:post] ? Post.new(sanitize(params[:post])) : Post.new(sanitize(params))

    if user_signed_in?

      current_user.posts << post
      post.user = current_user

      current_user.save
      post.save

    end

    options = {}
    options[:user] = current_user if current_user
    render :json => post.public_model(options)

  end

  def index
    options = {}
    options[:company] = [current_company.name] if company_signed_in?
    options[:page] = (params[:page] || 1).to_i

    posts = Post.paged_posts(options)

    render :json => Post.public_models(posts)
  end

  def new
    post = Post.new(params[:post])

    render :json => post.public_model
  end

  def vote_up

    post = Post.find_by_id(params[:post_id])

    current_user.vote_for(post)

    render :json => post
  end


  def sanitize(model)
    sanitized = {}
    Post.attr_accessible[:default].each do |attr|
      sanitized[attr] = model[attr] if model[attr]
    end
    sanitized
  end
end
