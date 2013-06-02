class Maple.Routers.ApplicationRouter extends Backbone.Router

  mainContainer = "#maple-main-container"

  initialize: (options) ->
    @posts = new Maple.Collections.PostsCollection()
    @posts.reset options.posts

    @companies = new Maple.Collections.CompaniesCollection()
    @companies.reset options.companies

    @current_company = options.current_company || {}

    Maple.session = new Maple.Models.Session()
    Maple.session.set(options.current_session)
    if options.current_company
      Maple.session.currentCompany.set(options.current_company)
    else if options.current_user
      Maple.session.currentUser.set(options.current_user)
    
    # Custom event aggregator for inter-view communication
    Maple.mapleEvents = _.extend({}, Backbone.Events)

    @users = new Maple.Collections.UsersCollection()
    
    @viewManager = new Maple.ViewManager()

    # no users bootstrapping
    # We'll lazy load instead
    

  routes:
    '' : 'index'
    'newPost' : 'newPost'
    'companies/:id' : 'showCompany'
    'companies/:id/dashboard' : 'dashboard'
    'users/:id' : 'showUser'
    'posts/:id' : 'showPost'
    'about' : 'about'
    'faq' : 'faq'
    'cod': 'cod'
    'terms': 'terms'
    'privacy': 'privacy'
    '*default' : 'index'

  index: ->
    if Maple.session.get("user_signed_in") || Maple.session.get("company_signed_in")
      view = new Maple.Views.MultiColumnView(
        collection: @posts
        parent: mainContainer
        modelView: Maple.Views.PostView
        bootstrapped: true
      )
      @viewManager.showView(view, $(mainContainer))
     

    else
      view = new Maple.Views.SplashView()
      @viewManager.showView(view, $(mainContainer))
    
    @company_pill_view = new Maple.Views.CompaniesIndexView({ collection: @companies})
  
  terms: ->
    view = new Maple.Views.TermsView()
    @viewManager.showView(view, $(mainContainer))

  privacy: ->
    view = new Maple.Views.PrivacyView()
    @viewManager.showView(view, $(mainContainer))

  about: ->
    view = new Maple.Views.AboutView()
    @viewManager.showView(view, $(mainContainer))

  cod: ->
    view = new Maple.Views.CodView(
      companies: @companies
      ads: @posts
    )
    @viewManager.showView(view, $(mainContainer))

  faq: ->
    view = new Maple.Views.FaqView()
    @viewManager.showView(view, $(mainContainer))

  newPost: ->
    $modal = $("#mainModal")
    $modal.modal('show').html new Maple.Views.NewPostView(
      collection: @posts
      companies: @companies
    ).el

    $modal.on 'hidden', =>
      @navigate("#", true)

  showCompany: (id) ->
    @company_pill_view && @company_pill_view.close()
    @companies.access {
      id: id
      success: (company) =>
        view = new Maple.Views.CompanyShowView({ model: company })
        @viewManager.showView(view, $(mainContainer))
      error: (company, xhr, options) =>
        Maple.Utils.alert({ err: xhr.status + ': ' + xhr.statusText })
      }

  dashboard: (id) ->
    company = @companies.get id
    view = new Maple.Views.CompaniesDashboardView({ model: company })
    @viewManager.showView(view, $(mainContainer))

  showUser: (id) ->
    @company_pill_view && @company_pill_view.close()
    @users.access {
      id: id
      success: (user) =>
        view = new Maple.Views.UserShowView({ model: user })
        @viewManager.showView(view, $(mainContainer))
      error: (user, xhr, options) =>
        Maple.Utils.alert({ err: xhr.status + ': ' + xhr.statusText })
    }

  showPost: (id) ->
    @posts.access {
      id: id
      success: (post) =>
        view = new Maple.Views.PostShowView({ model: post })
        @viewManager.showView(view, $(mainContainer))
      error: (post, xhr, options) =>
        Maple.Utils.alert({ err: xhr.status + ': ' + xhr.statusText })
    }

