class Maple.Views.PostView extends Backbone.View

  template: JST["backbone/templates/posts/post"]

  render: ->
    console.log("Rendering a post view")
    @$el.html(@template(@model.toJSON()))
    return this