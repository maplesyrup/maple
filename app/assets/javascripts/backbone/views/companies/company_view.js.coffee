class Maple.Views.CompanyView extends Backbone.View
  # Display a company inside of
  # li.company DOM element.

  tagName: "div"

  className: "company"

  template: JST["backbone/templates/companies/company"]

  initialize: ->
    @render()

  render: ->
    @$el.html(@template(@model.toJSON()))
    @
