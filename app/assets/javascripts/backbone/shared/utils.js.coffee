class Maple.Utils
	# Utilities class for Maple
	#
	#	For nitty gritty repeatable 
	# javascript that no one wants 
	# to write a second time

	@uploadFile: (_file, _url, _onsuccess, _onerror)=>
		form = new FormData()
		form.append 'file', _file	
		@upload(form, _url, _onsuccess, _onerror)

	@uploadForm: (_data, _url, _onsuccess, _onerror) ->

		$.ajax({
			url: _url
			type: 'POST'
			data: _data
			processData: false
			cache: false
			contentType: false
			success: (data) -> _onsuccess(data)
			error: (data) -> _onerror(data)
		})




