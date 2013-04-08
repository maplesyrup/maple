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

	imageResourceName: 'company[splash_image]' 

	tagName: 'div'

	className: 'maple-image-upload-container'

	template: JST['backbone/templates/shared/upload_image']
	
	events:
		"drop #photo-drop-bin" : "handleDrop"	 	
		"dragover #photo-drop-bin" : "handleDragover"
		"mouseover #photo-drop-bin" : "toggleFolder"
		"mouseout #photo-drop-bin" : "toggleFolder"
		"dragenter #photo-drop-bin" : "toggleFolder"
		"dragleave #photo-drop-bin" : "toggleFolder"
		"click	.icon-remove" : "exitView"
		"click 	.company-image-folder": "selectImageFromFile"
		"click #save-image-button" : "saveImage"

	initialize: -> 
		@render()

	render: ->
		@$el.html(@template(@model.toJSON())) # quick template render
		@

	handleDrop: (event) ->
		event.stopPropagation()
		event.preventDefault()
		e = event.originalEvent
		e.dataTransfer.dropEffect = 'copy'

		@newImgFile = e.dataTransfer.files[0]

		reader = new FileReader()
		reader.onloadstart = ->
			$('.file-loading').toggle()

		reader.onloadend = ->
			$('#company-header-image').css('background', 'url(' + reader.result + ') no-repeat center center')
			$('.file-loading').toggle()
		reader.readAsDataURL(@newImgFile)	
	
	toggleFolder: (event) ->
		$("#opened-folder").toggle()
		$("#closed-folder").toggle()
	
	handleDragover: (event) ->
		event.preventDefault()	

	saveImage: (event) ->

		if @newImgFile
			formData = new FormData()
			formData.append @imageResourceName, @newImgFile 

		else
			formData = new FormData($("#add-splash-image")[0])

		Maple.Utils.upload(
			formData,
			@model.url(), 
			((post) =>
				@exitView
				console.log("success")),
			((e) =>
				@exitView 
				console.log(e)),
			type:
				"PUT")

	updateSplashImage: (image) ->
		console.log image

	selectImageFromFile: (event) ->
		$("#splash-image-field").click()
			
	exitView: (event) -> 
		@remove()		
		@unbind()
