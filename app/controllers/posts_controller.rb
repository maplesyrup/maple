class PostsController < ApplicationController

  def create
    if params[:token]
      user = FbGraph::User.me(params[:token])
      user = user.fetch
      logged_in_user = User.find_by_uid(user.identifier)
      sign_in(:user, logged_in_user)
      params[:post].delete :token
    end

    @post = Post.new(params[:post])

    if user_signed_in?
      @post.save
      user = User.find(current_user.id)

      user.posts << @post
      @post.user = user

      if @post.save
        user.save
        redirect_to :action => "index"
      else
        render :action => "new"
      end

    end

  end

  def all
    @posts = Post.paged_posts
  end

  def index
    if company_signed_in?
      # If a company is signed in, render company specific view
      @companyTaggedPosts = Post.find(:all, :conditions => ["company_id = ?", current_company.id])

      respond_to do |format|
        format.html
        format.json { render :json => @companyTaggedPosts.to_json({:include => {:user => { :only => [:uid, :email] }, :company => { :only => :name} }, :methods => [:image_url, :total_votes]}).html_safe }
      end
    else
      # Just render normal view
      @posts = Post.paged_posts

    end
  end

  def new
    @post = Post.new(params[:post])
    @companies = Company.all
  end

  def vote_up

    post = Post.find_by_id(params[:post_id])

    current_user.vote_for(post)

    render :json => post
  end
end
