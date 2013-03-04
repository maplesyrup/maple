class Maple.Models.Post extends Backbone.Model
  paramRoot: 'post'

  defaults:

class Maple.Collections.PostsCollection extends Backbone.Collection
  model: Maple.Models.Post
  url: '/posts'
