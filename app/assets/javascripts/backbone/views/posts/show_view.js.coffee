class Maple.Views.PostShowView extends Backbone.View
  
  template: JST["backbone/templates/posts/show"]
  events:
    "click #new-comment": "newComment"

  initialize: ->
    @model.comments.fetch(
      data:
        post_id: @model.id
      success: =>
        @render()
      error: =>
        console.log "error"
    )

  render: =>
    @$el.html(@template(_.extend(@model.toJSON(), Maple.session.toJSON(),
      comments:
        @model.comments.toJSON()
    )))
  
  newComment: (event) ->
    event.preventDefault()
    event.stopPropagation()
    content = $("#new-comment-area").val()
    if !Maple.Utils.emptyString(content)
      if Maple.session.get("user_signed_in")
        comment = new Maple.Models.Comment(
          content: content
          commentable_id: @model.id
          commentable_type: 'Post'
        )
        comment.save({},
          success: (post) =>
            @model.comments.add(post)
            @render()
          error: (error) =>
            console.log error
        )
