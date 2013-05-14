class Maple.Views.CampaignShowView extends Backbone.View
  # Displays a campaign

  template: JST["backbone/templates/campaigns/show"]
  
  events:
    "click .campaign-glimpse" : "focusCampaign"
    "click #create-campaign" : "createCampaign"
    "keyup #starttime" : "parseDatetime" 
    "keyup #endtime" : "parseDatetime"  

  initialize: ->
    # Listener for tabbing between campaign and campaign show 
    Maple.mapleEvents.bind("blurCampaign", @render)
    @reloadCollection()
  
  render: (collection) =>
    @$el.html(@template(
      _.extend(@model.toJSON(),
      campaigns:
        current: @currentCampaigns.toJSON()
        future: @futureCampaigns.toJSON()
        past: @pastCampaigns.toJSON()
      Maple.session.toJSON())))  
    @
  
  filterCollection: ->
    @currentCampaigns = @collection.current()
    @pastCampaigns = @collection.past()
    @futureCampaigns = @collection.future()

  reloadCollection: ->
    @collection.fetch
      success: =>
        @filterCollection() 
        @render()
      data: 
        company_id: @model.id

  parseDatetime: (event) -> 
    parsed = Date.parse($(event.target).val())
    if parsed != null 
      if event.target.id == "starttime"
        $("#starttimeinput").html(parsed.toString())
      else 
        $("#endtimeinput").html(parsed.toString())
  
  flashAlert: (container, message) ->
    container.html(message)
    container.css('display', 'block')

  isEmpty: (object) ->
    if !object || object == ""
      true
    false

  createCampaign: (event) ->
    form = $("#new-campaign-form")
    title = form.find("input[name='title']").val()
    description = form.find("textarea[name='description']").val()

    starttime = new Date($("#starttimeinput").html()).getTime()
    endtime = new Date($("#endtimeinput").html()).getTime()
    
    alertContainer = $("#campaign-alert")
    if @isEmpty(title)
      @flashAlert(alertContainer, "Title can't be blank")
    else if @isEmpty(description)
      @flashAlert(alertContainer, "Description can't be blank")
    else if @isEmpty(starttime)
      @flashAlert(alertContainer, "Start can't be blank")
    else if @isEmpty(endtime)
      @flashAlert(alertContainer, "End can't be blank")
    else if starttime > endtime
      @flashAlert(alertContainer, "Campaign can't start after it ends")
    else if starttime < ( new Date().getTime() - 60000 )
      @flashAlert(alertContainer, "Campaign can't start in the past")
    else
      $("#campaign-alert").css('display', 'none')
      newCampaign = new Maple.Models.Campaign()
      newCampaign.save({
        title: title
        description: description
        starttime: starttime
        endtime: endtime
        time_type: 'jstime'
        },
        {
        success: (model) =>
          $("#new-campaign-modal").modal('hide')
          @collection.add(model)
          @filterCollection()
          @render()
        error: (error) =>
          console.log error
        }
      )

  focusCampaign: (event) ->
    target = $(event.currentTarget)
   
    event.preventDefault()
    event.stopPropagation()

    model = @collection.get(target.attr("campaign-id"))
    @$el.html new Maple.Views.CampaignView(
      model: model
    ).el
    
  close: ->
    @unbind()
