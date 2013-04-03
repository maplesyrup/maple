class Maple.Models.Post extends Backbone.Model
  paramRoot: 'post'

class Maple.Collections.PostsCollection extends Backbone.Collection
	model: Maple.Models.Post
	url: -> '/posts/'

	company: (id) ->
		new Maple.Collections.PostsCollection @where company_id: id


# All constants and enums declared here for post
Maple.Post =
  VOTED:
    YES: 'yes'
    NO: 'no'
    UNAVAILABLE: 'unavailable'
