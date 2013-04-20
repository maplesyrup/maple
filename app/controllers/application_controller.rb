class ApplicationController < ActionController::Base
  #protect_from_forgery

  def home
    @posts = Post.paged_posts({ :sort => { :by => 'total_votes' } })
    @companies = Company.paged_companies
  end
end
