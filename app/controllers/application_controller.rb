class ApplicationController < ActionController::Base
  #protect_from_forgery

  def home
    @posts = Post.paged_posts({ :sort => { :by => 'total_votes' } })
    @companies = Company.paged_companies
  end

  def sessions
    render :json => { :current_user => current_user.id, :current_company => current_company && current_company.id } 
  end
end
