class Maple.Views.CompanyView extends Backbone.View

  tagName: "li"

  className: "company"

  template: JST["backbone/templates/companies/company"]

  initialize: ->
    @render()

  render: ->
    @$el.html(@template(@model.toJSON()))
    @
