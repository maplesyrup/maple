class Maple.Views.CompanyShowView extends Backbone.View
  # Display a company inside of
  # li.company DOM element.

  tagName: "div"

  className: "company"

  template: JST["backbone/templates/companies/show"]

  events:
    "focus [contenteditable]" : "editContent"
    "blur [contenteditable]" : "updateContent"

  initialize: ->
    @model.on "change", =>
      if @model.hasChanged("logo_urls")
        replaceImageTemplate = JST["backbone/templates/helpers/replace_image"]
        @$el.find("#logo-placeholder").html(replaceImageTemplate({url: @model.get("logo_urls").medium}))

    @render()

  render: ->
    @$el.html(@template(@model.toJSON()))
    @model.posts.fetch # lazy fetch of associated posts
      data: 
        company_id: @model.id
      success: =>
        @$el.find("#company-posts-container").html(new Maple.Views.PostsIndexView({ collection: @model.posts }).el)
    @

  submitLogo: (event) ->
    event.preventDefault()
    event.stopPropagation()

    formData = new FormData($('#add-company-logo')[0])

    $.ajax({
      url: @model.url(),
      type: 'PUT',
      success: (company) =>
        @model.set(company)
        $("#uploadLogoModal").modal('hide')
      error: (e) => console.log(e),
      data: formData,
      cache: false,
      contentType: false,
      processData: false
    })

  saveContent: (id, content) ->
    if id ==  "company-blurb-title"
      @model.set({ blurb_title: content })
    else if id == "company-blurb-body"
      @model.set({ blurb_body: content })
    else if id == "company-more-info-title"
      @model.set({ more_info_title: content })
    else if id == "company-more-info-body"
      @model.set({ more_info_body: content })
    else if id == "company-logo-field"
      @model.set({ logo: content })
    else
      return false 

    @model.patch(
      ["blurb_title", 
      "blurb_body", 
      "more_info_title", 
      "more_info_body"])
  
  updateContent: (event) ->
    target = $(event.currentTarget)
    targetID = target.attr("id")
    @saveContent(targetID, target.html()) 
      
  editContent: (event) ->
    event.stopPropagation()
    event.preventDefault()
    
    target = $(event.currentTarget)
    if target.attr("id") == "company-header-image"
      @$el.find("#company-select-new-image").html( new Maple.Views.UploadImageView({ model: @model }).el)
    else 
      return false
