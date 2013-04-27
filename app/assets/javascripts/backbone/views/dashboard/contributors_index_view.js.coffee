class Maple.Views.DashboardContributorsView extends Backbone.View

  template: JST["backbone/templates/dashboard/contributors_index"]

  initialize: ->
    @addAll()
    @render()

  addAll: ->
    @collection.forEach(@addOne, @)

  @addOne: (model) ->
    @view = new Maple.Views.DashboardContributorsSingleView({ })
    @$el.append @view.render().el 

  render: ->
    @$el.html(template())
    @
