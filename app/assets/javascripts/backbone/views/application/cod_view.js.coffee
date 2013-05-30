class Maple.Views.CodView extends Backbone.View

  template: JST["backbone/templates/application/cod"]

  initialize: ->
    $.ajax(
      type: 'GET'
      url: '/stats'
      success: (results) =>
        @render(results)
      error: (e) ->
        Maple.Utils.alert({ err: "Could not fetch stats" })
    )

    @

  render: (data) ->
    @$el.html @template(data)
    @

  close: ->
    @remove()
    @unbind()
