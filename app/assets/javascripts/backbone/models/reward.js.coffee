class Maple.Models.Reward extends Backbone.Model
  paramRoot: 'reward'
  urlRoot: '/rewards'

class Maple.Collections.RewardsCollection extends Backbone.Collection
  model: Maple.Models.Reward
  url: '/rewards'
