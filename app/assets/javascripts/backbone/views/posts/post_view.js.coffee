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
    "click .endorsable": "endorse"
    "click .untag-post": "untagPost"
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

  untagPost: (event) =>
    event.stopPropagation()
    event.preventDefault()

    @model.save({ company: null, campaign: null },
      url: @model.paramRoot + @model.id + '/untag'
      success: (model) =>
        console.log("Successfully untagged: " + model.id)
      error: (model, xhr, options) =>
        Maple.Utils.alert({ err: xhr.status + ': ' + xhr.statusText }))

  render: ->
    @$el.html(@template(_.extend(@model.toJSON(), Maple.session.toJSON())))
    @

  endorse: (event) ->
    if Maple.session.get("company_signed_in") == true
      target = $(event.currentTarget)
      target.toggleClass("gold icon-star-empty icon-star")

      $.ajax
        type: "POST"
        url: "/posts/endorse"
        data:
          id: @model.get('id')
        success: (post) =>
          console.log("endorsed")
        error: (xhr) =>
          Maple.Utils.alert({ err: xhr.status + ': ' + xhr.statusText })

  close: ->
    @remove()
    @unbind()
    @.model.unbind()
