class Maple.Views.PostView extends Backbone.View

  template: JST["backbone/templates/posts/post"]

  render: ->
    @$el.html(@template(@model.toJSON()))
    return this