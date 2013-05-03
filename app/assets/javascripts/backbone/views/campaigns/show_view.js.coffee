class Maple.Views.CampaignShowView extends Backbone.View
  # Displays a campaign
 
  className: "campaign"
  
  template: JST["backbone/templates/campaigns/show"]
 
  initialize: -> 
    @collection.fetch 
      success: => 
        @render()
     
  
  render: ->
    @$el.html(@template(_.extend(@collection.toJSON(), Maple.session.toJSON())))
    @
