class PostsController < ApplicationController

  def create
    # post posts/:id
    #
    # This route will create a new ad with the given id. It will
    # also log in mobile users that are posting an ad.
    post = Post.new(sanitize(params[:post]))

    success = false

    if user_signed_in?

      current_user.posts << post
      post.user = current_user

      current_user.save
      success = post.save

    end

    options = {}
    options[:user] = current_user if current_user
    if success
      render :json => post.public_model(options)
    else
      render :json => post.public_model(options),
             :status => Rack::Utils.status_code(400)
    end
  end

  def index
    # get posts
    #
    # This route will return all the posts and filter if there are
    # options specified. Currently we can filter by company
    posts = Post.paged_posts(params)

    render :json => Post.public_models(posts, {:user => current_user})
  end

  def new
    # get posts/new
    #
    # This route will a new post with the specified parameters without
    # saving it to the database
    post = Post.new(params[:post])

    render :json => post.public_model
  end

  def update
    if user_signed_in?
      post = current_user.posts.find_by_id(params[:post][:id])
      if post
        post.update_attributes(sanitize(params[:post]))
        render :json => post.public_model

      end
    else
      redirect_to :controller => 'users', :action => 'login_in'
    end
  end

  def untag
    authenticate_company!

    post = Post.find_by_id(params[:id])

    if current_company.id == post.company_id
      current_company.posts.delete(post)
      post.campaign.posts.delete(post) if post.campaign
      post.banned_companies << current_company
      post.company = nil
      post.campaign = nil
      post.save
      current_company.save
      render :json => post.public_model
    else
      # Forbidden to modify post
      render :json => post.public_model,
             :status => Rack::Utils.status_code(403)
    end
  end

  def vote_up
    # post posts/vote_up
    #
    # This will increment the vote for the selected post by 1

    post = Post.find_by_id(params[:post_id])

    current_user.vote_for(post)
    post.save
    Post.index.refresh

    post.campaign.refresh_rewards if post.campaign

    render :json => post
  end

  def endorse
    authenticate_company!

    post = current_company.posts.find_by_id(params[:id])
    if post
      post.endorsed = !post.endorsed
      post.save
      Post.index.refresh

      post.campaign.refresh_rewards if post.campaign
      render :json => post
    else
      render :json => {}, :status => 404
    end
  end

  def destroy
    post = Post.destroy(params[:id])

    render :json => post.public_model
  end

  def sanitize(model)
    sanitized = {}
    Post.attr_accessible[:default].each do |attr|
      sanitized[attr] = model[attr] if model[attr]
    end
    sanitized
  end
end
