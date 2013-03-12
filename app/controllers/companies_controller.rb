class CompaniesController < ApplicationController

  def index
    @companies = Company.paged_companies
  end

end
