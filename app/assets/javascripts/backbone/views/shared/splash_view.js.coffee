class Maple.Views.SplashView extends Backbone.View

  template: JST["backbone/templates/shared/splash"]
  
  initialize: ->
    @render()

  render: ->
    @$el.html(@template())
    @

  close: ->
    @unbind()
    @remove()
