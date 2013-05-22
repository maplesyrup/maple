class Maple.Models.Comment extends Backbone.Model
  paramRoot: 'comment'
  url: '/comments'

class Maple.Collections.CommentsCollection extends Backbone.Collection
  model: Maple.Models.Comment
  url: '/comments'
   

