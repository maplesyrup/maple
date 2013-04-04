class Maple.Views.NewPostView extends Backbone.View
    # Associates the current View with
    # a div.newPost DOM element.
    # Binds an event on the submit button
    # so we do a POST request on the
    # form elements and close the form
    # after we finish submitting it.

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
        window.router.navigate('/')
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



