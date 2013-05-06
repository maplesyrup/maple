class Maple.Views.CampaignShowView extends Backbone.View
  # Displays a campaign
 
  className: "campaign"
  
  template: JST["backbone/templates/campaigns/show"]
  
  event:
    "click #create-campaign" : "createCampaign"

  initialize: ->
    @reloadCollection()
  
  render: (collection) ->
    @$el.html(@template(
      _.extend(@model.toJSON(),
      campaigns:
        current: @currentCampaigns.toJSON()
        future: @futureCampaigns.toJSON()
        past: @pastCampaigns.toJSON()
      Maple.session.toJSON())))
    @

  reloadCollection: ->
    @collection.fetch
      success: =>
        @currentCampaigns = @collection.current()
        @pastCampaigns = @collection.past()
        @futureCampaigns = @collection.future()
        @render()
 
  createCampaign: (event) ->
    console.log event
