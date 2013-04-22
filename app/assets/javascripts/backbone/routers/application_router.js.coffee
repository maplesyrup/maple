class Maple.Routers.ApplicationRouter extends Backbone.Router

  initialize: (options) ->
    @posts = new Maple.Collections.PostsCollection()
    @posts.reset options.posts

    @companies = new Maple.Collections.CompaniesCollection()
    @companies.reset options.companies

    @current_company = options.current_company || {}

    @session = new Maple.Models.Session()
    @session.set(options.current_session)
    if options.current_company
      @session.currentCompany.set(options.current_company)
    else if options.current_user
      @session.currentUser.set(options.current_user)

    @users = new Maple.Collections.UsersCollection() 
    
    # no users bootstrapping 
    # We'll lazy load instead 

  routes:
    '' : 'index'
    'newPost' : 'newPost'
    'companies/:id' : 'showCompany'
    'companies/:id/dashboard' : 'dashboard'
    'users/:id' : 'showUser'
    '*default' : 'index'

  index: ->
    $("#maple-main-container").html new Maple.Views.MultiColumnView(
      collection: @posts
      parent: "#maple-main-container"
      modelView: Maple.Views.PostView
      ).el
    
    @company_pill_view = new Maple.Views.CompaniesIndexView({ collection: @companies})

  newPost: ->
    $modal = $("#mainModal")
    $modal.modal('show').html new Maple.Views.NewPostView(
      collection: @posts
      companies: @companies).el
    
    $modal.on 'hidden', =>
      @navigate("#", true)

  showCompany: (id) ->
    @company_pill_view && @company_pill_view.close()
    @companies.access {
      id: id
      success: (company) =>
        $("#maple-main-container").html new Maple.Views.CompanyShowView({ 
          model: company,
          session: @session,
          }).el  
      }

  dashboard: (id) ->
    company = @companies.get id
    $("#maple-main-container").html( new Maple.Views.CompaniesDashboardView({ model: company }).el )

  showUser: (id) ->
    @company_pill_view && @company_pill_view.close()
    @users.access {
      id: id
      success: (user) =>
        $("#maple-main-container").html new Maple.Views.UserShowView({ 
          model: user, 
          session: @session
          }).el
    }
