class Maple.Views.RewardView extends Backbone.View
  template: JST["backbone/templates/posts/post"]

  initialize: ->
    @render()

  render: ->
    @$el.html(@template(_.extend(@model.toJSON(), Maple.session.toJSON())))
    @
