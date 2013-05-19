class Maple.Models.Comment extends Backbone.Model
  paramRoot: 'comment'

class Maple.Collections.CommentsCollection extends Backbone.Collection
  model: Maple.Models.Comment
   

