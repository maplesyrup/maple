class CampaignsController < ApplicationController
  before_filter :authenticate_company!, :except => [:index, :show]

  def index
    campaigns = Campaign.paginate(:page => params[:page] || 1, :per_page => 30)
    campaigns = Company.find_by_id(params[:company_id]).campaigns.
      find(:all, :order => "starttime") if params[:company_id].present?

    render :json => Campaign.public_models(campaigns)
  end

  def create
    campaign = current_company.campaigns.create(sanitize(params[:campaign]))
    render :json => campaign.public_model  
  end

  def destroy
    # reject if company not signed in  
    to_destroy = current_company.campaigns.find(params[:id])
    if to_destroy
      # only destroy if owned by compan
      destroyed = to_destroy.destroy
      render :json => destroyed.public_model 
    else
      render :json => {}, :status => 403 
    end
  end

  def update
    to_update = current_company.campaigns.find(params[:id])
    if to_update
      to_update.update_attributes(sanitize(params[:campaign]))
      render :json => to_update.public_model
    else
      render :json => {}, :status => 403
    end
  end

  def show
    campaign = Campaign.find_by_id(params[:id])
    render :json => campaign.public_model  
  end 
  
  def sanitize(model)
    sanitized = {}
    Campaign.attr_accessible[:default].each do |attr|
      sanitized[attr] = model[attr] if model[attr]
    end
    sanitized
  end
end
