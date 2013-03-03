class Maple.Models.User extends Backbone.Model
  paramRoot: 'user'



class Maple.Collections.UsersCollection extends Backbone.Collection
  model: Maple.Models.User
  url: '/users'
