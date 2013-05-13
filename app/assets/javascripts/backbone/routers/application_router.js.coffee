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

    @users = new Maple.Collections.UsersCollection()

    # no users bootstrapping
    # We'll lazy load instead

  routes:
    '' : 'index'
    'newPost' : 'newPost'
    'companies/:id' : 'showCompany'
    'companies/:id/dashboard' : 'dashboard'
    'users/:id' : 'showUser'
    'about' : 'about'
    'faq' : 'faq'
    'cod': 'cod'
    '*default' : 'index'

  index: ->
    $(mainContainer).html new Maple.Views.MultiColumnView(
      collection: @posts
      parent: mainContainer
      modelView: Maple.Views.PostView
      bootstrapped: true
    ).el

    @company_pill_view = new Maple.Views.CompaniesIndexView({ collection: @companies})

  about: ->
    $(mainContainer).html( new Maple.Views.AboutView().el )

  cod: ->
    $(mainContainer).html new Maple.Views.CodView(
      companies: @companies
      ads: @posts
    ).el

  faq: ->
    $(mainContainer).html( new Maple.Views.FaqView().el )

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
        $(mainContainer).html new Maple.Views.CompanyShowView({
          model: company,
          }).el
      error: (company, xhr, options) =>
        Maple.Utils.alert({ err: xhr.status + ': ' + xhr.statusText })
      }

  dashboard: (id) ->
    company = @companies.get id
    $(mainContainer).html( new Maple.Views.CompaniesDashboardView({ model: company }).el )

  showUser: (id) ->
    @company_pill_view && @company_pill_view.close()
    @users.access {
      id: id
      success: (user) =>
        $(mainContainer).html new Maple.Views.UserShowView({
          model: user,
          }).el
      error: (user, xhr, options) =>
        Maple.Utils.alert({ err: xhr.status + ': ' + xhr.statusText })
    }
