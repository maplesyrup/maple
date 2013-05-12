module ApplicationHelper
  def render_google_analytics
    return '' if not Rails.env.production?
    render 'shared/google_analytics'
  end

end
