class CommentsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]

  def index
    comments = {}
    if params[:user_id]      
      comments = User.find_by_id(params[:user_id]).comments
    elsif params[:post_id]
      comments = Post.find_by_id(params[:post_id]).comments
    end
    render :json => Comment.public_models(comments)
  end  

  def create
    comment = current_user.comments.create(sanitize(params[:comment]))
    render :json => comment.public_model
  end

  def sanitize(model)
    sanitized = {}    
    Comment.attr_accessible[:default].each do |attr|
      sanitized[attr] = model[attr] if model[attr]    
    end
    sanitized
  end
end
