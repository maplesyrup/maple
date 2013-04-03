class Maple.Views.CompaniesIndexView extends Backbone.View
  # Associate the current View with
  # the .companies DOM element.
  # For every Company inside of the
  # Collection, render a Company View
  # and append it to the end of the
  # .companies DOM element.

  el: ".companies"

  template: JST["backbone/templates/companies/index"]

  initialize: ->
    @render()
    @addAll()

  addAll: ->
    @collection.forEach(@addOne, @)

  addOne: (model, index) ->
    @view = new Maple.Views.CompaniesPillView({ model: model })

    @$el.append @view.render().el


  render: ->
    @$el.html @template()
    @
