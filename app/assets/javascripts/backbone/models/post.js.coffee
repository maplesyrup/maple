class Maple.Models.Post extends Backbone.Model
  paramRoot: 'post'

  VOTED:
    YES: 'yes'
    NO: 'no'
    UNAVAILABLE: 'unavailable'


class Maple.Collections.PostsCollection extends Backbone.Collection
	model: Maple.Models.Post
	url: -> '/posts/'

	company: (id) ->
		new Maple.Collections.PostsCollection @where company_id: id


