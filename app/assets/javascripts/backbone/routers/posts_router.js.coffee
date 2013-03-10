class Maple.Routers.PostsRouter extends Backbone.Router

  initialize: (options) ->
    @posts = new Maple.Collections.PostsCollection
    @posts.reset options.posts

  routes:
    "" : "index"

    "*default" : "index"

  index: ->
    @view = new Maple.Views.PostsIndexView({ collection: @posts })
