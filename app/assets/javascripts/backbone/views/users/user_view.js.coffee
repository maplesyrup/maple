class Maple.Views.UserView extends Backbone.View
  # Renders a View for a Single company. 

  template: JST["backbone/templates/users/user_thumb"]

  initialize: ->
    @render()

  render: ->
    @$el.html(@template(@model.toJSON()))
    @

  close: ->
    @remove
    @unbind
    @.model.unbind
