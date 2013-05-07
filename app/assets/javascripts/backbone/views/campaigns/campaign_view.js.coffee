class Maple.Views.CampaignView extends Backbone.View
  
  el: '#campaign-container'
 
  template: JST["backbone/templates/campaigns/campaign"]

  events:
    "click #back-to-campaigns" : "blurCampaign"
    "click #create-award" : "createAward"

  initialize: -> 
    @reloadCollection()
  
  render: ->
    @$el.html(@template(
      _.extend(@model.toJSON(),
        rewards:
          @model.rewards.toJSON()
        Maple.session.toJSON()
      )))
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

  blurCampaign: (event) ->
    event.preventDefault()
    event.stopPropagation()
    @close()
    Maple.mapleEvents.trigger("blurCampaign")

  flashAlert: (container, message) ->
    container.html(message)
    container.css('display', 'block')

  isEmpty: (object) ->
    if !object || object == ""
      true
    false

  createAward: (event) ->
    form = $("#new-reward-form")
    title = form.find("input[name='title']").val()
    description = form.find("textarea[name='description']").val()
    reward = form.find("input[name='reward']").val()
    minVotes = form.find("input[name='min-votes']").val()
    quantity = form.find("input[name='quantity']").val()
    
    alertContainer = $("#reward-alert")

    if @isEmpty(title) 
      @flashAlert(alertContainer, "Title can't be blank")
    else if @isEmpty(reward) 
      @flashAlert(alertContainer, "Reward can't be blank") 
    else if @isEmpty(quantity)
      @flashAlert(alertContainer, "Quantity Can't be blank")
    else
      alertContainer.css('display', 'none')
      newReward = new Maple.Models.Reward() 
      newReward.save({
        title: title
        description: description
        reward: reward
        quantity: quantity
        min_votes: minVotes
        campaign_id: @model.id
        },
        {
        success: (model) =>
          $("#new-reward-modal").modal('hide')
          @model.rewards.add(model)
          @render() 
        error: (error) =>
          console.log error
        }
      )

  close: ->
    @unbind()
