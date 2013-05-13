class Maple.Views.FaqView extends Backbone.View

  tagName: "div"

  className: "container faq-container"

  template: JST["backbone/templates/application/faq"]

  initialize: ->
    @render()

  render: ->
    @$el.html @template()
    @

  close: ->
    @$el.html("")
    @unbind()

