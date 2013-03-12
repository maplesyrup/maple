class Maple.Views.PostView extends Backbone.View

  template: JST["backbone/templates/posts/post"]

  events:
    "click .vote": "vote"

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
    @.model.set({'total_votes': num_votes + 1, 'voted_on': 1})

  render: ->
    @$el.html(@template(@model.toJSON()))
    @
