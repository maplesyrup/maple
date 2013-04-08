class CompaniesController < ApplicationController

  def index
    # get companies
    #
    # This will get all the companies (30 at a time)
    companies = Company.paged_companies
  	render :json => Company.public_models(companies)
  end

  def show
  	# show company
  	#
  	# This will show a specific company
  	if current_company && current_company.id == params[:id].to_i
  		render :json => current_company.public_model({:user => current_user, :company => current_company})
  	else
  		render :json => Company.find(params[:id]).public_model({:user => current_user, :company => current_company})
    end
  end
  
  def update
    @company = Company.find(params[:id])
    if current_company && current_company.id == @company.id
      @company.update_attributes(sanitize(params[:company]))
      render :json => @company.public_model({:user => current_user, :company => current_company})
      #render :json => {}, :status => 200
    else
      render :json => {}, :status => 403 
    end
  end

  def sanitize(model)
    sanitized = {}
    Company.attr_accessible[:default].each do |attr|
      sanitized[attr] = model[attr] if model[attr]
    end
    sanitized
  end
end
