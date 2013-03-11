class PostsController < ApplicationController

  def create
    @post = Post.new(params[:post])

    if user_signed_in?
      puts "We are inside of the user signed in of posts#create"
      puts "The current user is:"
      puts current_user
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

  def index
    @posts = Post.paged_posts

    respond_to do |format|
      format.html
      format.json { render :json => @posts.to_json({:include => {:user => { :only => [:uid, :email] }, :company => { :only => :name} }, :methods => [:image_url, :total_votes]}).html_safe }
    end

  end

  def new
    @post = Post.new(params[:post])
    @companies = Company.all
  end

  def vote_up
    if user_signed_in?
      post = Post.find_by_id(params[:post_id])
      user = User.find_by_id(current_user.id)

      user.vote_for(post)
    end
  end
end
