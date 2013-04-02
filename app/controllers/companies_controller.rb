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
  		render :json => current_company.public_model
  	else
  		render :json => Company.find(params[:id]).public_model
	end
  end 
end

