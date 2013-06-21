module ApplicationHelper
  def render_google_analytics
    return '' if not Rails.env.production?
    render 'shared/google_analytics'
  end

  def render_clicktale_top
    return '' if not Rails.env.production?
    render 'shared/clicktale_top'
  end

  def render_clicktale_bottom
    return '' if not Rails.env.production?
    render 'shared/clicktale_bottom'
  end

end
