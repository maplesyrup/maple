class ApplicationController < ActionController::Base
  #protect_from_forgery

  def home
    @CONSTANTS = { :FACEBOOK_APP_ID => FACEBOOK_APP_ID }
    @posts = Post.paged_posts()
    @companies = Company.paged_companies
  end

  def percent_change(prev, now)
    pct = (((now - prev) / prev.to_f) * 100).round(2)
    return pct.nan? ? 0 : pct
  end
end
