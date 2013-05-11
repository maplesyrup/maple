class Maple.Views.CodView extends Backbone.View

  template: JST["backbone/templates/application/cod"]

  initialize: ->
    $.ajax(
      type: 'GET'
      url: '/stats'
      success: (results) ->
        console.log(results)
      error: (e) ->
        console.log(e)
    )
    
    @render()
    @

  render: ->
    @$el.html @template()
    @
