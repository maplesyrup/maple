class ApplicationController < ActionController::Base
  #protect_from_forgery

  def home
    @posts = Post.paged_posts
    @companies = Company.paged_companies
  end
end
