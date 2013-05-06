class Maple.Models.Campaign extends Backbone.Model
  paramRoot: 'campaign'
  urlRoot: '/campaigns'

  initialize: -> 
    @rewards = new Maple.Collections.RewardsCollection
    @rewards.url = '/campaigns/' + @id + '/rewards'

class Maple.Collections.CampaignsCollection extends Backbone.Collection
  model: Maple.Models.Campaign
  url: '/campaigns'

  orderBy: (options) ->   
    ordering = options.descending == true ? -1 : 1 
    _.sortBy(@, (campaign) ->
      campaign.get(options.type || "endtime") * ordering
    )

  current: -> 
    filtered = @filter((campaign) ->
      now = new Date()
      Maple.Utils.fromRubyDateTime(campaign.get("starttime")) < now && 
        Maple.Utils.fromRubyDateTime(campaign.get("endtime")) > now 
    )
    new Maple.Collections.CampaignsCollection(filtered)

  future: ->
    filtered = @filter((campaign) ->
      Maple.Utils.fromRubyDateTime(campaign.get("starttime")) >= new Date()
    )
    new Maple.Collections.CampaignsCollection(filtered)

  past: -> 
    filtered = @filter((campaign) ->
      Maple.Utils.fromRubyDateTime(campaign.get("endtime")) <= new Date() 
    )
    new Maple.Collections.CampaignsCollection(filtered)
