class RewardsController < ApplicationController

  def index
    rewards = Reward.all
 
    if params[:campaign_id]
      rewards = Campaign.find_by_id(params[:campaign_id]).rewards 
    end

    campaign = params[:campaign_id]
    render :json => Reward.public_models(rewards) 
  end

  def create
    if company_signed_in? && current_company.id == 
      Campaign.find_by_id(params[:campaign_id]).company.id
      # Verify that company is logged in and that 
      # the campaign being edited belongs to the logged 
      # in company   
      reward = Campaign.find_by_id(params[:campaign_id])
        .rewards.new(sanitize(params[:reward]))
      reward.save
      render :json => reward.public_model 
    else
      render :json => {}, :status => 403
    end
  end

  def show
    reward = Reward.find_by_id(params[:id])
    render :json => reward.public_model
  end

  def destroy
    # How should we handle destroy in this case ? 
  end
  
  def update
    if company_signed_in?
      reward = Reward.find_by_id(params[:id])
      if current_company.id == reward.campaign.company.id
        reward.update_attributes(sanitize(params[:reward]))
        render :json => reward.public_model
      else
        render :json => {}, :status => 403
      end
    else
      render :json => {}, :status => 403
    end
  end

  def sanitize(model)
    sanitized = {}
      Reward.attr_accessible[:default].each do |attr|
        sanitized[attr] = model[attr] if model[attr]
      end
    sanitized
  end
end
