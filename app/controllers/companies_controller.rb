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
  	@company_editable = false
  	if current_company && current_company.id == params[:id].to_i
  		@company_editable = true
  		@company = current_company
  	else
  		@company = Company.find(params[:id])
	end
  end 
end

