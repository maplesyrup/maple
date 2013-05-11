class Maple.Views.CodView extends Backbone.View

  template: JST["backbone/templates/application/cod"]

  initialize: ->
    @render()
    @

  render: ->
    @$el.html @template()
    @
