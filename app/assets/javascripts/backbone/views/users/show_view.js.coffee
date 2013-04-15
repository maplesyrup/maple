class Maple.Views.UserShowView extends Backbone.View

	tagName: 'div'
	
	className: 'company'

	template: JST["backbone/templates/users/show"]
  
	events:
		"blur [contenteditable]" : "updateContent"	

	initialize: ->
		@render()

	render: ->
		@$el.html(@template(@model.toJSON()))
		@model.posts.fetch # lazy fetch of associated posts
			data: 
				user_id: @model.id
			success: =>
				@$el.find("#user-main-container").html(new Maple.Views.PostsIndexView({ collection: @model.posts, parent: "#user-main-container" }).el)
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

###
	editContent: (event) ->
    event.stopPropagation()
    event.preventDefault()
    
    target = $(event.currentTarget)
    targetID = target.attr("id")
    if targetID == "avatar"
      @$el.find("#user-select-new-avatar").html( new Maple.Views.UploadImageView({ model: @model }).el)
    else
      return false
###