class Maple.Routers.ApplicationRouter extends Backbone.Router

  initialize: (options) ->
    @posts = new Maple.Collections.PostsCollection()
    @posts.reset options.posts

    @companies = new Maple.Collections.CompaniesCollection()
    @companies.reset options.companies

    @current_company = options.current_company || {}
    @users = new Maple.Collections.UsersCollection()
    # no user bootstrapping. We'll lazy load instead 
     
  routes:
    '' : 'index'
    'newPost' : 'newPost'
    'companies/:id' : 'showCompany'
    'dashboard' : 'dashboard'
    'users/:id' : 'showUser'
    '*default' : 'index'

  index: ->
    $("#maple-main-container").html(new Maple.Views.PostsIndexView({ collection: @posts}).el)
    @company_pill_view = new Maple.Views.CompaniesIndexView({ collection: @companies})

  newPost: ->
    @view = new Maple.Views.NewPostView({ collection: @posts, companies: @companies })

  showCompany: (id) ->
    @company_pill_view && @company_pill_view.close()
    company = @companies.get id 
    if company
      # Use existing model if possible
      $("#maple-main-container").html( new Maple.Views.CompanyShowView({ model: company }).el )  
    
    else
      # Fetch model and add to collection
      company = new Maple.Models.Company({ id: id })
      company.fetch success: (data) =>
        $("#maple-main-container").html( new Maple.Views.CompanyShowView({ model: company }).el )
        @companies.add company

  dashboard: ->
    company = @companies.get @current_company.id
    $("#maple-main-container").html( new Maple.Views.CompaniesDashboardView({ model: company }).el )

  showUser: (id) ->
    @company_pill_view.close()
    user = @users.get id
    if user
      # Use existing model if possible
      $("#maple-main-container").html( new Maple.Views.UserShowView({ model: user }).el )

    else
      # Fetch model and add to collection
      user = new Maple.Models.User({ id: id })
      user.fetch success: (data) =>
        $("#maple-main-container").html( new Maple.Views.UserShowView({ model: user }).el )
        @users.add user 
