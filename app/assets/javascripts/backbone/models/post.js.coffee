class Maple.Models.Post extends Backbone.Model
  paramRoot: 'post'
  urlRoot: '/posts/'

  initialize: ->
    @comments = new Maple.Collections.CommentsCollection

class Maple.Collections.PostsCollection extends Backbone.Collection
  model: Maple.Models.Post
  url: -> '/posts/'

  company: (id) ->
    new Maple.Collections.PostsCollection @where company_id: id

  byCampaign: (id) ->
    new Maple.Collections.PostsCollection @where campaign_id: id

  byReward: (id) ->
    filtered = @filter((post) ->
      _.where(post.get("rewards"),
        id: id
      ).length != 0 )
    new Maple.Collections.PostsCollection filtered

# All constants and enums declared here for post
Maple.Post =
  VOTED:
    YES: 'yes'
    NO: 'no'
    UNAVAILABLE: 'unavailable'
