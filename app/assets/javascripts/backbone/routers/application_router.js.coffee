class Maple.Routers.ApplicationRouter extends Backbone.Router

  initialize: (options) ->
    @posts = new Maple.Collections.PostsCollection()
    @posts.reset options.posts

    @companies = new Maple.Collections.CompaniesCollection()
    @companies.reset options.companies

  routes:
    '' : 'index'
    '*default' : 'index'

  index: ->
    @view = new Maple.Views.PostsIndexView({ collection: @posts})
    @view = new Maple.Views.CompaniesIndexView({ collection: @companies})

