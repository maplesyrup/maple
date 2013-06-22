class Maple.Models.Reward extends Backbone.Model
  paramRoot: 'reward'
  urlRoot: '/rewards'
  validate: (attrs, options) ->
    if @isEmpty(attrs.title)
      return "The title can't be empty"
    else if @isEmpty(attrs.reward)
      return "The reward can't be empty"
    else if @isEmpty(attrs.quantity) || parseInt(attrs.quantity) < 0
      return "You must include a positive numeric quantity"
    else if parseInt(attrs.min_votes) < 0
      return "Minimum number of votes can't be less than zero"
    
  isEmpty: (object) ->
    if !object || object == ""
      return true
    return false
        
class Maple.Collections.RewardsCollection extends Backbone.Collection
  model: Maple.Models.Reward
  url: '/rewards'
