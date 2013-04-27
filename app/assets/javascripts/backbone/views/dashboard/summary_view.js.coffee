class Maple.Views.DashboardSummaryView extends Backbone.View

  template: JST["backbone/templates/dashboard/summary"]

  initialize: ->
    @render()
    @

  render: ->
    @$el.html(@template(@collection))
    @



