class Maple.Views.PrivacyView extends Backbone.View

  tagName: "div"

  className: "container privacy-container"

  template: JST["backbone/templates/application/privacy"]

  initialize: ->
    @render()

  render: ->
    @$el.html @template()
    @

  close: ->
    @$el.html("")
    @unbind()
