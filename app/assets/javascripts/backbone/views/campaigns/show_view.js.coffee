class Maple.Views.CampaignShowView extends Backbone.View
  # Displays a campaign
 
  className: "campaign"
  
  template: JST["backbone/templates/campaigns/show"]
  
  events:
    "click #create-campaign" : "createCampaign"
    "keyup #starttime" : "parseDatetime" 
    "keyup #endtime" : "parseDatetime"  

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

  createCampaign: (event) ->
    form = $("#new-campaign-form")
    title = form.find("input[name='title']").val()
    description = form.find("textarea[name='description']").val()

    starttime = new Date($("#starttimeinput").html()).getTime()
    endtime = new Date($("#endtimeinput").html()).getTime()
     
    if !title || title == ""
      $("#campaign-alert").html("Title can't be blank") 
        .css('display', 'block')
    else if !description || description == ""
      $("#campaign-alert").html("Description can't be blank")
        .css('display', 'block')
    else if !starttime
      $("#campaign-alert").html("Start can't be blank")
        .css('display', 'block')
    else if !endtime
      $("#campaign-alert").html("Ending can't be blank")
        .css('display', 'block')
    else if starttime > endtime 
      $("#campaign-alert").html("Your campaign can't start after it ends") 
        .css('display', 'block')
    else if starttime < ( new Date().getTime() - 60000 )
      $("#campaign-alert").html("Your campaign can't start in the past")
        .css('display', 'block')
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
