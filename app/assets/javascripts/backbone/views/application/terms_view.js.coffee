class Maple.Views.TermsView extends Backbone.View

  tagName: "div"

  className: "container terms-container"

  template: JST["backbone/templates/application/terms"]

  initialize: ->
    @render()

  render: ->
    @$el.html @template()
    @

  close: ->
    @$el.html("")
    @unbind()
