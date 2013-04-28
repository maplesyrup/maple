class Maple.Views.CompaniesStatSingleView extends Backbone.View

  template: JST["backbone/templates/dashboard/stats_single"]

  initialize: ->
    @render()

  render: ->
    @$el.html(@template(@model.toJSON()))
    @
