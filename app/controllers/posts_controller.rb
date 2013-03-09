class PostsController < ApplicationController

  def create
    print "Inside of create controller"
    @post = Post.new(params[:post])

    if user_signed_in?
      print "Inside of User signed in"
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
    print "Inside of new controller"
    @post = Post.new(params[:post])


  end
end
