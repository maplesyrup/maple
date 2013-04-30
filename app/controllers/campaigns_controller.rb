class CampaignsController < ApplicationController
  def index
    campaigns = Campaign.paginate(:page => params[:page] || 1, :per_page => 30)
    campaigns = Company.find_by_id(params[:company_id]).campaigns if params[:company_id].present?

    render :json => Campaign.public_models(campaigns)
  end

  def create
    if company_signed_in? && params[:company_id].to_i == current_company.id 
      campaign = Company.find_by_id(params[:company_id])
                .campaigns.new(sanitize(params[:campaign]))
      campaign.save
      render :json => campaign.public_model  
    else
      render :json => {}, :status => 403
    end
  end

  def destroy
    if company_signed_in?
      # reject if company not signed in  
      to_destroy = Campaign.find_by_id(params[:id])
      if to_destroy.company_id == current_company.id
        # only destroy if owned by compan
        destroyed = to_destroy.destroy
        render :json => destroyed.public_model 
      else
        render :json => {}, :status => 403 
      end
    else 
      render :json => {}, :status => 403
    end
  end

  def update
    if company_signed_in?
      to_update = Campaign.find_by_id(params[:id])
      if to_update.company_id == current_company.id
        to_update.update_attributes(sanitize(params[:campaign]))
        render :json => to_update.public_model
      else
        render :json => {}, :status => 403
      end
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
