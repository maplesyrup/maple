class CompaniesController < ApplicationController

  def index
    companies = Company.paged_companies
  	render :json => Company.public_models(companies)
  end
end

