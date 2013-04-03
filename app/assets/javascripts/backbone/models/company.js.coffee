class Maple.Models.Company extends Backbone.Model
  paramRoot: 'company'
  urlRoot: '/companies'

  initialize: ->
  	@posts = new	Maple.Collections.PostsCollection
  	@posts.url = '/posts'	 	
 			 
class Maple.Collections.CompaniesCollection extends Backbone.Collection
  model: Maple.Models.Company
  url: '/companies'
