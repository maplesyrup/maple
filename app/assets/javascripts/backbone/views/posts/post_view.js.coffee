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
    "click .nominatable": "nominate"
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

  externalData: ->
    # Any additional json to patch into the 
    # template

    nominated = false
    nominatable_reward = _.where(@model.get("rewards"), requirement: "COMPANY-NOMINATED")

    if nominatable_reward.length != 0
      nominated = true

    {
      nominated: nominated
    }

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
    externals = @externalData()
    @$el.html(@template(_.extend(@model.toJSON(), Maple.session.toJSON(), externals)))
    @

  nominate:(event) ->
    target = $(event.currentTarget)
    target.toggleClass("gold icon-star-empty icon-star")

  close: ->
    @remove()
    @unbind()
    @.model.unbind()
