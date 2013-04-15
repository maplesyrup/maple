class Maple.Views.CompaniesStatsView extends Backbone.View
  # Display the textual stats
  # on a company's dashboard

  tagName: "div"

  className: "row-fluid"

  id: "dashboard-stats"

  template: JST["backbone/templates/companies/dashboard/stats_index"]

  initialize: ->
    @render()
    @addAll()

  addAll: ->
    @collection.forEach(@addOne, @)

  addOne: (model, index) ->
    @view = new Maple.Views.CompaniesStatSingleView({ model: model })
    @$el.append @view.render().el

  render: ->
    @$el.html(@template())
    @
