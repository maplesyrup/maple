class Maple.Views.UploadImageView extends Backbone.View
	#	Class for displaying image upload UI 
	#
	# To Use: 
	#	Call this view and pass in the model 
	# and the image (some models may have
	# multiple images) resource that you 
	# want to update. 
	#
	# Functionality: 
	# The view will save
	# the changed resource using the 
	# model's url. 

	tagName: 'div'

	className: 'maple-image-upload-container'

	template: JST['backbone/templates/shared/upload_image']


	initialize: -> 
		@render()

	render: ->
		@$el.html(@template(@model.toJSON())) # quick template render
		@




