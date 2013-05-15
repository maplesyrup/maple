class Maple.Models.Company extends Backbone.Model
  paramRoot: 'company'
  urlRoot: '/companies'

  initialize: ->
    @posts = new	Maple.Collections.PostsCollection
    @posts.url = '/posts'
    @followers = new Maple.Collections.UsersCollection
    @campaigns = new Maple.Collections.CampaignsCollection

class Maple.Collections.CompaniesCollection extends Backbone.Collection
  model: Maple.Models.Company
  url: '/companies'

  search: (str) ->
    if (str == '')
      @

    pattern = new RegExp(str, "gi")
    return _(@filter (data) ->
      return pattern.test(data.get("name"))
    )

