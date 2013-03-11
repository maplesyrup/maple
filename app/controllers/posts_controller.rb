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
  end

  def new
    @post = Post.new(params[:post])
    @companies = Company.all


  end
end
