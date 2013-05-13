class ApplicationController < ActionController::Base
  #protect_from_forgery

  def home
    @CONSTANTS = { :FACEBOOK_APP_ID => FACEBOOK_APP_ID }
    @posts = Post.paged_posts({ :sort => { :by => 'total_votes' } })
    @companies = Company.paged_companies

    if !current_user && !current_company  
      render :template => "application/splash"
    end

  end

  def percent_change(prev, now)
    pct = (((now - prev) / prev.to_f) * 100).round(2)
    return pct.nan? ? 0 : pct
  end
end
