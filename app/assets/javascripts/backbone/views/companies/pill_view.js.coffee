class Maple.Views.CompaniesPillView extends Backbone.View
 
  tagName: 'li'

  template: JST['backbone/templates/companies/pill']

  initialize: ->
    @render()

  render: ->
    @$el.html(@template(@model.toJSON()))
    @
  
  close: ->
    @unbind()
    @remove()
