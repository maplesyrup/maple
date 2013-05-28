class Maple.Views.PostView extends Backbone.View
  # Renders a View for a Single Post.
  # Binds a click event on the vote
  # button to send a POST request and
  # register the vote.
  # Events modifying the underlying
  # model's attributes will rerender
  # the View.

  template: JST["backbone/templates/posts/post"]

  events:
    "click .vote": "vote"
    "click .delete-post": "deletePost"
    "mouseover" : "onMouseover"
    "mouseout" : "onMouseout"

  initialize: ->
    @.model.bind 'change', =>
      if(@.model.hasChanged('total_votes'))
        @.render()

    @render()

  onMouseover: (e) =>
    @$el.find('.delete-post').css 'visibility', 'visible'
    @$el.find('.outer-feature').css 'visibility', 'visible'
    @$el.find('.header-feature').css 'visibility', 'visible'

  onMouseout: (e) =>
    @$el.find('.delete-post').css 'visibility', 'hidden'
    @$el.find('.outer-feature').css 'visibility', 'hidden'
    @$el.find('.header-feature').css 'visibility', 'hidden'

  vote: ->
    num_votes = @.model.get('total_votes')

    $.ajax
      type: "POST"
      url: "/posts/vote_up"
      data: "post_id=" + @.model.get('id')
      success: =>
        console.log("Success")
      error: (xhr) =>
        Maple.Utils.alert({ err: xhr.status + ': ' + xhr.statusText })

    @.model.set({'total_votes': num_votes + 1, 'voted_on': Maple.Post.VOTED.YES})

  deletePost: (event) =>
    event.stopPropagation()
    event.preventDefault()

    @collection.remove(@model)


  render: ->
    @$el.html(@template($.extend(@model.toJSON(), Maple.session.toJSON())))
    @

  close: ->
    @remove()
    @unbind()
    @.model.unbind()
