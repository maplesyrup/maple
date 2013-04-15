class Maple.Views.UserShowView extends Backbone.View

	tagName: 'div'
	
	className: 'company'

	template: JST["backbone/templates/users/show"]
	
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
