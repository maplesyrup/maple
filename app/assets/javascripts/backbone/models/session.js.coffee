class Maple.Models.Session extends Backbone.Model
  url: 'application/session'

  initialize: ->
    @currentUser = new Maple.Models.User()
    @currentCompany = new Maple.Models.Company()

  toJSON: ->
    attr = _.clone(@attributes)
    _.each(attr, (value, key)-> 
      if _(value.toJSON).isFunction()
        attr[key] = value.toJSON())

    jsonObject = _.extend(attr,
      "session": 
        "currentCompany": @currentCompany.toJSON(),
        "currentUser": @currentUser.toJSON())
