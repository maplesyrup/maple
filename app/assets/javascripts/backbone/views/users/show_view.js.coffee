class Maple.Views.UserShowView extends Backbone.View

  tagName: 'div'
  
  className: 'company'

  template: JST["backbone/templates/users/show"]
  
  events:
    "blur [contenteditable]" : "updateContent"	
    "focus [contenteditable]": "editContent"
    "click .activity-filter" : "refilterThumbs"

  initialize: ->
    @render()

  render: ->
    @$el.html(@template(@model.toJSON()))
    @model.posts.fetch # lazy fetch of associated posts
      data: 
        user_id: @model.id
      success: =>
        @$el.find("#user-main-container").html new Maple.Views.MultiColumnView(
          collection: @model.posts
          parent: "#user-main-container"
          thumbView: Maple.Views.PostView
        ).el
    @

  saveContent: (id, content) ->
    if id ==  "personal-info"
      @model.set({ personal_info: content })
    else
      return false 

    @model.patch(
      ["personal_info"])

  updateContent: (event) ->
    target = $(event.currentTarget)
    targetID = target.attr("id")
    @saveContent(targetID, target.html()) 

  editContent: (event) ->
    event.stopPropagation()
    event.preventDefault()
    
    target = $(event.currentTarget)
    targetID = target.attr("id")
    if targetID == "avatar"
      @$el.find("#user-select-new-avatar").html( 
        new Maple.Views.UploadImageView({ model: @model, inputName: "user[avatar]", targetImgContainer: "#avatar", resourceName: "avatar"}).el)
    else
      return false
  ###
  populateThumbs: (thumbType) ->
    collection, parent, thumbView
    switch thumbType
      when "user-posts"
        collection = @model.posts
        parent = "#user-main-container"
        thumbView = Maple.Views.PostView
      when "user-likes"

      when "user-following"
         
      when "user-followers"
        collection = @model
  ###

  refilterThumbs: (event) -> 
    event.stopPropagation()
    event.preventDefault()

    target = $(event.currentTarget)
    targetID = target.attr("id")
    @model.posts.access({"id": 1})
