class Maple.Views.CompanyShowView extends Backbone.View
  # Display a company inside of
  # li.company DOM element.

  tagName: "div"

  className: "company"

  template: JST["backbone/templates/companies/show"]

  events:
    "focus [contenteditable]" : "editContent"
    "blur [contenteditable]" : "updateContent"
    "click #company-submit-logo" : "submitLogo"
  
  # body...
  initialize: ->
    @render()

  render: ->
    console.log(@model)
    @$el.html(@template(@model.toJSON()))
    @model.posts.fetch
      data: 
        company_id: @model.id
      success: =>
        @$el.find("#company-posts-container").html(new Maple.Views.PostsIndexView({ collection: @model.posts }).el)
    @

  submitLogo: (event) ->
    event.preventDefault()
    event.stopPropagation()

    formData = new FormData($('#add-company-logo')[0])
    console.log(formData)
    console.log(@model)

    $.ajax({
      url: '/companies/' + @model.id,
      type: 'PUT',
      success: (company) =>
        console.log("Edited company")
        #@collection.add([post])
        #@close()
        #window.router.navigate('/')
      error: (e) => console.log(e),
      data: formData,
      cache: false,
      contentType: false,
      processData: false
    })

    '''
    console.log(logoField.val())
    console.log(logoField.files[0])
    console.log(logoField.files[0].getAsBinary())

    console.log("a")
    '''
    #@saveContent(targetID, )

  saveContent: (id, content) ->
    if id ==  "company-blurb-title"
      @model.set({ blurb_title: content })
    else if id == "company-blurb-body"
      @model.set({ blurb_body: content })
    else if id == "company-more-info-title"
      @model.set({ more_info_title: content })
    else if id == "company-more-info-body"
      @model.set({ more_info_body: content })
    else if id == "company-splash-image"
      @model.set({ splash_image: content }) 
    else if id == "company-logo-field"
      @model.set({ logo: content })
    else
      return ""
    @model.save()
  
  updateContent: (event) ->
    target = $(event.currentTarget)
    targetID = target.attr("id")
    @saveContent(targetID, target.html()) 
      
  editContent: (event) ->
    target = $(event.currentTarget)
