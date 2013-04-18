class Maple.Models.Session extends Backbone.Model
  url: 'application/session'

  initialize: ->
    @currentUser = new Maple.Models.User()
    @currentCompany = new Maple.Models.Company() 