class Maple.Models.User extends Backbone.Model
  paramRoot: 'user'

  defaults:

class Maple.Collections.UsersCollection extends Backbone.Collection
  model: Maple.Models.User
  url: '/users'
