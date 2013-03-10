class PostsController < ApplicationController

  def create
    #@post = Post.new(params[:post])
    @post = Post.new(:title => params[:post][:title], :content => params[:post][:title], :image => params[:post][:image])

    if user_signed_in?
      @post.save
      user = User.find(current_user.id)
      company = Company.find_by_id(params[:company])

      company.posts << @post
      user.posts << @post

      @post.company = company
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
  end

  def new
    @post = Post.new(params[:post])
    @companies = Company.all


  end
end
