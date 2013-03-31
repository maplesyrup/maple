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

  	company = Company.find(params[:id])
  	render :json => Company.public_models(company)
  end
end

