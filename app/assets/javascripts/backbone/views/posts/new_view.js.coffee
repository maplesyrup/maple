class Maple.Views.NewPostView extends Backbone.View

  className: 'newPost'

  tagName: 'div'

  template: JST["backbone/templates/posts/new"]

  events:
    'click #post-submit' : 'save'

  initialize:(options) ->
    @companies =  options.companies
    @render()

  render: ->
    @$el.html @template({ companies: @companies.toJSON() })
    $("body").append @$el


  save: (e) =>
    e.preventDefault()
    e.stopPropagation()

    formData = new FormData($('#new-post')[0])

    $.ajax({
      url: '/posts',
      type: 'POST',
      success: (post) =>
        @collection.add([post])
        @close()
        window.location.hash = ''
      error: (e) => console.log(e),
      data: formData,
      cache: false,
      contentType: false,
      processData: false
    })

  validate: (e) =>
    console.log(e)

  close: =>
    @$el.remove()
    @unbind()



