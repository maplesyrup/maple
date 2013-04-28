class Maple.Views.DashboardContributorsSingleView extends Backbone.View

  template: JST["backbone/templates/dashboard/contributors_single"]

  initialize: ->
    @render()
    @

  render: ->
    @$el.html(@template(@model))
    @