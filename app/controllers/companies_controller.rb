class CompaniesController < ApplicationController

  def index
    @companies = Company.paged_companies
  end

  def all
    @companies = Company.paged_companies
  	render :json => @companies.to_json(:only => [:name, :id])
  end

end
