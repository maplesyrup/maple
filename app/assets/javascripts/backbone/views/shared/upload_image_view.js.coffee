class Maple.Views.UploadImageView extends Backbone.View
	#	Class for displaying image upload UI 
	#
	# Functionality: 
	# The view will save
	# the changed resource using the 
	# model's url. 

	# for some added flexibility  
	
	# the name normally seen on the file ie "company[splash_image]" 
	inputName: '' 					

	#	where the image will be displayed ie "#image_container"
	targetImgContainer: ''

	#	name of the resource in the model ie "my-image"
	resourceName: ''

	tagName: 'div'

	className: 'maple-image-upload-container'

	template: JST['backbone/templates/shared/upload_image']
	
	events:
		# File reading events
		"drop #photo-drop-bin" : "handleDrop"	 
		"change #splash-image-field" : "handleClick"
		"click 	.company-image-folder": "selectImageFromFile"
		"click #save-image-button" : "saveImage"

		# UI Events
		"dragover #photo-drop-bin" : "handleDragover"
		"mouseover #photo-drop-bin" : "toggleFolder"
		"mouseout #photo-drop-bin" : "toggleFolder"
		"dragenter #photo-drop-bin" : "toggleFolder"
		"dragleave #photo-drop-bin" : "toggleFolder"
		"click	.icon-remove" : "exitView"

	initialize: ->
		@inputName = @options.inputName
		@targetImgContainer = @options.targetImgContainer
		@resourceName = @options.resourceName
			
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
		@previewFile(@newImgFile)				

	handleClick: (data) ->
		@newImgFile = data.target.files[0]
		if @newImgFile
			@previewFile(@newImgFile)

	previewFile: (file, options) ->		

		reader = new FileReader()
		reader.onloadstart = =>
			$('.file-loading').toggle()

		reader.onloadend = =>
			$(@targetImgContainer).attr("src", reader.result)
			$('.file-loading').toggle()

		reader.readAsDataURL(file)

	saveImage: (event) ->

		if @newImgFile
			formData = new FormData()
			formData.append @inputName, @newImgFile 

			@model.savePaperclip(formData,
			 type: 'PUT',
				success: (data) =>
					@model.set(@resourceName, data[@resourceName])	
					@close(data)

				error: (data) =>
					console.log "an error occured while saving"
					@exitView())	

	selectImageFromFile: (event) ->
		$("#splash-image-field").click()
	
	toggleFolder: (event) ->
		$("#opened-folder").toggle()
		$("#closed-folder").toggle()
	
	handleDragover: (event) ->
		event.preventDefault()	# required for drag and drop. Chrome bug	

	exitView: ->
		$(@targetImgContainer).attr("src", @model.get(@resourceName))	
		@close()

	close: (event) ->	
		@remove()		
		@unbind()
