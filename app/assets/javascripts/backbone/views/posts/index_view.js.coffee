class Maple.Views.PostsIndexView extends Backbone.View

  el: '#posts'

  template: JST["backbone/templates/posts/index"]

  initialize: ->
    @render
    @addAll

  addAll: ->
    @collection.forEach(@addOne, @)

  addOne: (model) ->
    @view = new Maple.Views.PostView({ model: model })
    @$el.find(".glimpse-column").append @view.render().el

  render: ->
    @$el.html @template()
    @