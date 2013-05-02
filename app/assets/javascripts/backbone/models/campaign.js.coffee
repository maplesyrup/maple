class Maple.Collections.CampaignsCollection extends Backbone.Collection
  model: Maple.Models.Campaign
  url: '/campaigns'

class Maple.Models.Campaign extends Backbone.Model
  paramRoot: 'campaign'
  urlRoot: '/campaigns'

  initialize: -> 
    @rewards = new Maple.Collections.RewardsCollection
    @rewards.url = '/campaigns/' + @id + '/rewards'

