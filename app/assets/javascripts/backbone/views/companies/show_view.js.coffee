class Maple.Views.CompanyShowView extends Backbone.View
  # Display a company inside of
  # li.company DOM element.

  tagName: "div"

  className: "company"

  template: JST["backbone/templates/companies/show"]

  events:
    "focus [contenteditable]" : "editContent"
    "blur [contenteditable]" : "updateContent"
    "click #company-header-image" : "newImageDialog"
 
  initialize: ->
    @render()

  render: ->
    @$el.html(@template(@model.toJSON()))
    @model.posts.fetch # lazy fetch of associated posts
      data: 
        company_id: @model.id
      success: =>
        @$el.find("#company-posts-container").html(new Maple.Views.PostsIndexView({ collection: @model.posts }).el)
    @

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
    else
      return ""
    @model.save()
  
  updateContent: (event) ->
    target = $(event.currentTarget)
    targetID = target.attr("id")
    @saveContent(targetID, target.html()) 
      
  editContent: (event) ->
    target = $(event.currentTarget)

  newImageDialog: (event) ->
    @$el.find("#company-select-new-image").html( new Maple.Views.UploadImageView({ model: @model }).el)
    @