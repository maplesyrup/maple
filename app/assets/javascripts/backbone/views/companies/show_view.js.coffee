class Maple.Views.CompanyShowView extends Backbone.View
  # Display a company inside of
  # li.company DOM element.

  tagName: "div"

  className: "company"

  template: JST["backbone/templates/companies/show"]

  initialize: ->
    @render()

  render: ->
    @$el.html(@template(@model.toJSON()))
    @
