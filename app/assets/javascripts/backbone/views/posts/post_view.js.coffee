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
    "click .maple-post": "showPost"

  initialize: ->
    @.model.bind 'change', =>
      if(@.model.hasChanged('total_votes'))
        @.render()

  vote: ->
    num_votes = @.model.get('total_votes')

    $.ajax
      type: "POST"
      url: "/posts/vote_up"
      data: "post_id=" + @.model.get('id')
      success: =>
        console.log("Success")
      error: =>
        console.log("There was an error")

    @.model.set({'total_votes': num_votes + 1, 'voted_on': Maple.Post.VOTED.YES})

  showPost: (event)->
    event.stopPropagation()
    event.preventDefault()

    $("#mainModal").modal('show').html new Maple.Views.PostShowView(
      model: @model
      ).el 

  render: ->
    @$el.html(@template(@model.toJSON()))
    @

  close: ->
    @remove
    @unbind
    @.model.unbind
