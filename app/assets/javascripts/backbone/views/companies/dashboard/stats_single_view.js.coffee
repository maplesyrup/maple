class Maple.Views.CompaniesStatSingleView extends Backbone.View

  template: JST["backbone/templates/companies/dashboard/stats_single"]

  initialize: ->
    @render()

  render: ->
    console.log()
    @$el.html(@template(@model.toJSON()))
    @
