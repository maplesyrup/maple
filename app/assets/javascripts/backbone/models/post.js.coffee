class Maple.Models.Post extends Backbone.Model
  paramRoot: 'post'

  initialize: ->
    @comments = new Maple.Collections.CommentsCollection

class Maple.Collections.PostsCollection extends Backbone.Collection
  model: Maple.Models.Post
  url: -> '/posts/'
          
  comparator: (model) ->
    return model.get('created_at')

  company: (id) ->
    new Maple.Collections.PostsCollection @where company_id: id

  _order_by: 'created_at'

  comparator: (model) ->
    if (@_order_by == 'created_at')
      return model.get('created_at')

  order_by_created_at: ->
    @_order_by = 'created_at'
    @sort()


# All constants and enums declared here for post
Maple.Post =
  VOTED:
    YES: 'yes'
    NO: 'no'
    UNAVAILABLE: 'unavailable'
