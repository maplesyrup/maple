class Maple.Routers.ApplicationRouter extends Backbone.Router

  initialize: (options) ->
    @posts = new Maple.Collections.PostsCollection()
    @posts.reset options.posts

    @companies = new Maple.Collections.CompaniesCollection()
    @companies.reset options.companies

    @current_company = options.current_company || {}

  routes:
    '' : 'index'
    'newPost' : 'newPost'
    'companies/:id' : 'showCompany'
    'dashboard' : 'dashboard'
    '*default' : 'index'

  index: ->
    $("#maple-main-container").html(new Maple.Views.PostsIndexView({ collection: @posts}).el)
    @view = new Maple.Views.CompaniesIndexView({ collection: @companies})

  newPost: ->
    @view = new Maple.Views.NewPostView({ collection: @posts, companies: @companies })

  showCompany: (id) ->
    company = @companies.get id
    that = @ 
    if company
      $("#maple-main-container").html( new Maple.Views.CompanyShowView({ model: company }).el )  
    else
      company = new Maple.Models.Company({ id: id })
      company.fetch success: (data) ->
      $("#maple-main-container").html( new Maple.Views.CompanyShowView({ model: company }).el )
      that.companies.add company

  dashboard: ->
    company = @companies.get @current_company.id
    $("#maple-main-container").html( new Maple.Views.CompaniesDashboardView({ model: company }).el )
