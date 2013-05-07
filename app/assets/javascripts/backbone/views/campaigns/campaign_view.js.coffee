class Maple.Views.CampaignView extends Backbone.View
  
  className: "campaign"
  
  template: JST["backbone/templates/campaigns/campaign"]
  
  initialize: -> 
    @reloadCollection()
  
  render: ->
    @$el.html(@template(
      _.extend(@model.toJSON(),
        Maple.session.toJSON()))) 
    @
  
  reloadCollection: ->
    @model.rewards.fetch(
      success: =>
        @render()
      error: =>
        console.log "oops"
      data:
        campaign_id: @model.id
    )
