class Maple.Views.DashboardContributorsView extends Backbone.View

  template: JST["backbone/templates/dashboard/contributors_index"]

  initialize: ->
    @render()
    @addAll()

  addAll: ->
    @collection.contributors.forEach(@addOne, @)

  addOne: (model) ->
    @view = new Maple.Views.DashboardContributorsSingleView({ model: model })
    @$el.append @view.render().el 

  render: ->
    @$el.html(@template())
    @
