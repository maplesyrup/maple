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
		type: 'PUT'
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
			url: jQuery.isFunction(@url) && @url() || @url
			type: (options && options.type) || 'POST'
			data: form
			processData: false
			cache: false
			contentType: false
			success: (data) ->
				(options && options.success	&& options.success(data))
			error: (xhr) ->
				(options && options.error(xhr))
		})

Backbone.Collection::access = (options) ->
	# Access
	#
	# Access function combines the get and
	# fetch into one method that
	# gets the model from the collection if
	# it exists or fetches the model from
	# the server.

	ret = @get(options.id)
	if ret
		options.success(ret)
	if not ret
		ret = new @model({ "id": options.id})
		ret.fetch {
			success: (data) =>
				@add ret
				options.success && options.success(ret)
			error: (data) ->
				options.error && options.error(data)
			}
	@

Maple.Utils =
  alert: (err) ->
    el = (new Maple.Views.AlertView(err)).render().el
    $(el).css 'left', ($(document).width() / 2) - ($(el).width() / 2)

  fromRubyDateTime: (integer_time) ->
    new Date(integer_time * 1000)
