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
				company_id: @model.id
			success: =>
				@$el.find("#user-posts-container").html(new Maple.Views.PostsIndexView({ collection: @model.posts }).el)
		@	   
