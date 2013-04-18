class ApplicationController < ActionController::Base
  #protect_from_forgery

  def home
    @posts = Post.paged_posts({ :sort => { :by => 'total_votes' } })
    @companies = Company.paged_companies
  end

  def sessions
    render :json => { :user_signed_in? => user_signed_in?,
                      :company_signed_in? => company_signed_in?,
                      :current_user => current_user && current_user.public_model.html_safe || nil, 
                      :current_company => current_company && current_company.public_model.html_safe || nil }
  end
end
