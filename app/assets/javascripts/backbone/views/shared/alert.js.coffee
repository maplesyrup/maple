class Maple.Views.AlertView extends Backbone.View

  el: ".alert-container"

  template: JST["backbone/templates/shared/alert"]

  initialize: ->
    @err = (@options.err || "Oops, something went wrong.")
    @render()

  render: ->
    @$el.html @template()
    @$el.find('.custom-message').text(@err)
    @$el.find('.alert').alert()
    @

  close: ->
    @unbind()
    @remove()

