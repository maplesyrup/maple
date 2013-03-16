class Maple.Views.CompaniesIndexView extends Backbone.View

  el: ".companies"

  template: JST["backbone/templates/companies/index"]

  initialize: ->
    @render()
    @addAll()

  addAll: ->
    @collection.forEach(@addOne, @)

  addOne: (model, index) ->
    @view = new Maple.Views.CompanyView({ model: model })

    @$el.append @view.render().el


  render: ->
    @$el.html @template()
    @
