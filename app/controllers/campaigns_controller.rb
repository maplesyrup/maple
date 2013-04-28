class CampaignsController < ApplicationController
  def index
    campaigns = Campaigns.paginate(:page => params[:page] || 1, :per_page => 30)
    campaigns = Company.find_by_id(params[:company_id]).campaigns if params[:company_id].present?
    render :json => public_models(campaigns)
  end

  def create
    campaign = Company.find_by_id(params[:company_id])
                .campaigns.create(params[:campaign])
    render :json => campaign.public_model  
  end

  def destroy

  end
  def update
  end
  def show
    campaign = Campaign.find_by_id(params[:id])
    render :json => campaign.public_model  
  end 
end
