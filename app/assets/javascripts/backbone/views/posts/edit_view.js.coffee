class Maple.Views.EditPostView extends Backbone.View

  id: 'editPost'

  tagName: 'div'

  template: JST["backbone/templates/posts/edit"]

  events:
    'click #post-submit' : 'save'

  initialize: (options) ->
    @submitLocked = false

    @render()

  render: ->
    @$el.html @template(_.extend(
      post:
        @model.toJSON()
    ))
    @

  save: (e) =>
    if !@submitLocked
      e.preventDefault()
      e.stopPropagation()

      data = @$el.find('#edit-post').serializeArray()
      attributes = {}

      data.forEach((datum) =>
        attributes[datum.name] = datum.value)

      $(".spinner").toggle()
      @submitLocked = true
      
      @model.set(attributes)

      @model.patch(_.keys(attributes),
        success: (post) =>

          @submitLocked = false
          $(".spinner").toggle()

          $("#mainModal").modal('hide')
          window.router.navigate('/posts/' + post.id, { trigger: true })
        error: (post, response, options) =>
          @submitLocked = false
          $(".spinner").toggle()
          $("#mainModal").modal('hide')
          Maple.Utils.alert({ err: response.status + ': ' + response.statusText }))

  validate: (e) =>
    console.log(e)

  close: =>
    @$el.remove()
    @unbind()
