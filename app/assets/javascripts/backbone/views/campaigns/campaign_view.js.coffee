class Maple.Views.CampaignView extends Backbone.View

  template: JST["backbone/templates/campaigns/campaign"]

  events:
    "click .reward-glimpse" : "filterByReward"
    "click #back-to-campaigns" : "blurCampaign"
    "click #submit-to-campaign" : "newPost"

  initialize: (options) ->
    @createRewardLocked = false
    @company = options.company || {}
    @reloadCollection()
     
  render: ->
    $("#competition-types").bind('click', @toggleAvailableFormInput)

    $("#create-award").bind("click", @createReward)
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
    Maple.mapleEvents.trigger("campaignFilter", "all-company-posts")
    Maple.mapleEvents.trigger("blurCampaign")

  flashAlert: (container, message) ->
    container.html(message)
    container.css('display', 'block')

  isEmpty: (object) ->
    if !object || object == ""
      true
    false

  createReward: (event) =>
    if !@createRewardLocked
      @createRewardLocked = true

      form = $("#new-reward-form")
      requirement = "MIN_VOTES"

      requirementType = $("input[type=radio]:checked").attr("id")
      quantity = form.find("input[name='quantity']").val()

      if requirementType == "top-post-type"
        requirement = "TOP_POST"
        quantity = form.find("input[name='top-post-quantity']").val()
      else if requirementType == "company-endorsed-type"
        requirement = "COMPANY_ENDORSED"

      title = form.find("input[name='title']").val()
      description = form.find("textarea[name='description']").val()
      reward = form.find("input[name='reward']").val()
      minVotes = form.find("input[name='min-votes']").val()
        
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
          requirement: requirement
          },
          {
          success: (model) =>
            $("#new-reward-modal").modal('hide')
            @createRewardLocked = false
            @model.rewards.add(model)
            @render()
          error: (error) =>
            @createRewardLocked = false
            Maple.Utils.alert({ err: xhr.status + ': ' + xhr.statusText })
          }
        )
  
  newPost: (event) ->
    if Maple.session.get("user_signed_in")
      # if user not signed in allow regular redirect to occur 
      event.preventDefault()
      event.stopPropagation()
      $modal = $("#mainModal")
      $modal.modal('show').html new Maple.Views.NewPostView(
        company: @company
        campaign: @model
        collection: @company.posts
      ).el

  filterByReward: (event) ->
    rewardId = $(event.currentTarget).attr("reward-id")
    Maple.mapleEvents.trigger("campaignFilter",
      type: "reward"
      id: rewardId
    )
    event.preventDefault()
    event.stopPropagation()

  toggleAvailableFormInput: (event) ->
    targetId = $(event.target).attr("id")

    if targetId == "top-post-type"
      $("#quantity-input").attr("disabled", "disabled")
      $("#top-posts-input").removeAttr("disabled")
      $("#qualifying-votes-input").removeAttr("disabled")
    else if targetId == "min-vote-type"
      $("#top-posts-input").attr("disabled", "disabled")
      $("#quantity-input").removeAttr("disabled")
      $("#qualifying-votes-input").removeAttr("disabled")
    else if targetId == "company-endorsed-type"
      $("#quantity-input").removeAttr("disabled")
      $("#qualifying-votes-input").attr("disabled", "disabled")
      $("#top-posts-input").attr("disabled", "disabled")

  close: ->
    $("#competition-types").unbind('click', @toggleAvailableFormInput)
    $("#create-award").unbind("click", @createReward)
    @remove()
    @unbind()
