class Maple.Routers.PostsRouter extends Backbone.Router

  initialize: (options) ->
    @posts = new Maple.Collections.PostsCollection
    @view = new Maple.Views.PostsIndexView({ collection: @posts})

  routes:
    '' : 'index'
    ':company' : 'filterByCompany'
    '*default' : 'index'

  index: ->
    @posts.urlParam = 'all'
    @posts.fetch()

  filterByCompany: (company)->
  	@posts.urlParam = 'company/' + company
  	@posts.fetch()
