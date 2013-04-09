class Maple.Models.User extends Backbone.Model
  paramRoot: 'user'
  urlRoot: '/users'
  
  initialize: ->
    @posts = new	Maple.Collections.PostsCollection
    @posts.url = '/posts'	

class Maple.Collections.UsersCollection extends Backbone.Collection
  model: Maple.Models.User
  url: '/users'
