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
    @model.on "change", =>
      if @model.hasChanged("logo_urls")
        @$el.find("#logo-placeholder").html('<img src="' + @model.get("logo_urls").medium + '"" />')

    @render()

  render: ->
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
