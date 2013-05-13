class Maple.Views.AboutView extends Backbone.View

  tagName: "div"

  className: "container about-container"

  template: JST["backbone/templates/application/about"]

  initialize: ->
    @render()

  render: ->
    @$el.html @template()
    @

  close: ->
    @$el.html("")
    @unbind()
