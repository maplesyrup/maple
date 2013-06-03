class Maple.Views.NewPostView extends Backbone.View
    # Associates the current View with
    # a div.newPost DOM element.
    # Binds an event on the submit button
    # so we do a POST request on the
    # form elements and close the form
    # after we finish submitting it.

  id: 'newPost'

  tagName: 'div'

  template: JST["backbone/templates/posts/new"]

  events:
    'click #post-submit' : 'save'

  initialize: (options) ->
    @submitLocked = false
    @companies =  options.companies
    @company = options.company
    @campaign = options.campaign

    @render()

  render: ->
    @$el.html @template(_.extend(
      companies:
        @companies && @companies.toJSON()
      company:
        @company && @company.toJSON()
      campaign:
        @campaign && @campaign.toJSON()))
    @


  save: (e) =>
    if !@submitLocked
      e.preventDefault()
      e.stopPropagation()

      formData = new FormData($('#new-post')[0])

      $(".spinner").toggle()
      @submitLocked = true

      @collection.savePaperclip(formData,
        success: (post) =>

          @submitLocked = false
          $(".spinner").toggle()

          @collection.add([post])
          $("#mainModal").modal('hide')
          window.router.navigate('/')
        error: (e) =>
          @submitLocked = false
          $(".spinner").toggle()
          console.log(e))
    
  validate: (e) =>
    console.log(e)

  close: =>
    @$el.remove()
    @unbind()



