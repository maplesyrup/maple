class CompaniesController < ApplicationController
  before_filter :authenticate_company!, :except => [:index, :show, :dashboard]

  def index
    # get companies
    #
    # This will get all the companies (30 at a time)
    options = params[:options] || {}

    followed = User.find(params[:follower]).
      follows_by_type('Company').
      map(&:followable_id) if params[:follower].present?

    options[:followed] = followed if !followed.nil?
    options[:followed] = [-1] if !followed.nil? && followed.empty?

    companies = Company.paged_companies(options)

  	render :json => Company.public_models(companies, options)
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
    if params[:company][:logo_id]
      current_company.assets.each do |asset|
        asset.selected = asset.id == params[:company][:logo_id].to_i
        asset.save
      end
    else

      if params[:company][:assets_attributes] && params[:company][:assets_attributes][0][:selected]
        current_company.assets.each do |asset|
          asset.selected = false
          asset.save
        end
      end

      current_company.update_attributes(sanitize(params[:company]))
    end

    render :json => current_company.public_model({:user => current_user, :company => current_company})
  end

  def destroy
    company = Company.delete(params[:id])

    render :json => company.public_model
  end

  def sanitize(model)
    sanitized = {}
    Company.attr_accessible[:default].each do |attr|
      sanitized[attr] = model[attr] if model[attr]
    end
    sanitized
  end

  def dashboard
    company = Company.find(params[:id])
    num_ads = company.posts.length
    num_followers = company.followers.length
    dashboard = { :num_ads => num_ads, :num_followers => num_followers }
    contributors = []

    company.posts.each do |post|
      user = post.user
      found = contributors.select { |c| c[:id] == user.id }

      if found.empty?
        contributors.push({:id => user.id, :name => user.name, :uid => user.uid, :num_ads => 1, :num_votes => post.votes.size})
      else
        found.first[:num_ads] += 1
        found.first[:num_votes] += post.votes.size
      end

    end

    contributors.sort_by { |c| c[:num_ads] }
    dashboard[:contributors] = contributors

    render :json => dashboard

  end
end
