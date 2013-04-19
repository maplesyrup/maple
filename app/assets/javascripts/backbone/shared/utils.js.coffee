Backbone.Model::patch = (attribute_whitelist, options)->
	# Patch
	#	
	#	As of 0.9.9, backbone.js officially supports 
	# PATCH. However, not all browsers support
	# this functionality. Attribute_whitelist
	# is a group of model attributes ["hand", "foot", "head"]
	# that you want to sync to the server. Options
	# is an additional object passed in by the user
	# containing error and success callbacks.  
	attrs = _.pick(@attributes, attribute_whitelist, 'id')
	cached_attrs = @attributes
	@attributes = attrs
	_options = {}
	_options.parse = true
				
	_options.success = (data)=>
		@attributes = cached_attrs
		options && options.success(data)
	_options.error = (data)=>
		@attributes = cached_attrs
		options && options.error(data)	
	
	method = 'update'
	@sync(method, @, _options)

Backbone.Model::follow = (options) ->
	# follow
	#
	# Purpose: Model action closely matching
	# Model action on the backend. 
	# Pass in type and target to options
	# and follow will send request with params
	# to back-end
	
	$.ajax({
		url: (options.url) || "users/follow"
		data: 
			type: options.type
			target: options.target
		success: (data) ->
			options.success(data)
		error: (data) ->
			options.error(data)		 	 		 
		})

Backbone.Collection::savePaperclip = Backbone.Model::savePaperclip = (form, options) ->
	# savePaperclip
	# 
	# save function that uploads images 
	# to the server using an ajax call
	# so that paperclip can use them

	$.ajax({
			url: @url()
			type: (options && options.type) || 'POST'
			data: form
			processData: false
			cache: false
			contentType: false
			success: (data) -> 
				(options	&& options.success(data)) 	
			error: (data) ->
				(options && options.error(data))	
		})	  
