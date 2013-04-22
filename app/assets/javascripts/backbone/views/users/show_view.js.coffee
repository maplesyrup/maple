class Maple.Views.UserShowView extends Backbone.View

  tagName: 'div'
  
  className: 'company'

  template: JST["backbone/templates/users/show"]
  
  events:
    "blur [contenteditable]" : "updateContent"	
    "focus [contenteditable]": "editContent"
    "click .activity-filter" : "refilterCollection"

  initialize: ->
    @render()

  render: ->
    @$el.html(@template(@model.toJSON()))
    @populateCollection("user-posts")

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

  populateCollection: (collectionType) ->
    switch collectionType
      when "user-posts"
        @model.posts.fetch # lazy fetch of associated posts
          data: 
            user_id: @model.id
          success: =>
            @$el.find("#user-main-container").html new Maple.Views.MultiColumnView(
              collection: @model.posts
              parent: "#user-main-container"
              modelView: Maple.Views.PostView
            ).el
      when "user-following"
        @model.companies_following.fetch
          data:
            follower: @model.id  
          success: =>
            @$el.find("#user-main-container").html new Maple.Views.MultiColumnView(
              collection: @model.companies_following
              parent: "#user-main-container"
              modelView: Maple.Views.CompanyView
            ).el

  refilterCollection: (event) -> 
    event.stopPropagation()
    event.preventDefault()

    target = $(event.currentTarget)
    targetID = target.attr("id")
