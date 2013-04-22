class Maple.Models.User extends Backbone.Model
  paramRoot: 'user'
  urlRoot: '/users'
  
  initialize: ->
    @posts = new	Maple.Collections.PostsCollection
    @posts.url = '/posts'
    
    @followers = new Maple.Collections.UsersCollection	
    @companies_following = new Maple.Collections.CompaniesCollection
    @users_following = new Maple.Collections.UsersCollection
          
class Maple.Collections.UsersCollection extends Backbone.Collection
  model: Maple.Models.User
  url: '/users'
