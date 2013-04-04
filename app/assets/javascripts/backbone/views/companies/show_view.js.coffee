class Maple.Views.CompanyShowView extends Backbone.View
  # Display a company inside of
  # li.company DOM element.

  tagName: "div"

  className: "company"

  template: JST["backbone/templates/companies/show"]

  events:
    "click .company-edit-content": "editContent"
    "mouseover .company-hover-content" : "toggleEdit" 
    "mouseout .company-hover-content" : "toggleEdit"
     
  # body...
  initialize: ->
    @render()

  render: ->
    @$el.html(@template(@model.toJSON()))
    @model.posts.fetch
      data: 
        company_id: @model.id
      success: =>
        @$el.find("#company-posts-container").html(new Maple.Views.PostsIndexView({ collection: @model.posts }).el)
    @

  getContent: (id) ->
    if id ==  "company-blurb-title"
      return  @model.attributes.blurb_title
    else if id == "company-blurb-body"
      return @model.attributes.blurb_body
    else if id == "company-more-info-title"
      return @model.attributes.more_info_title
    else if id == "company-more-info-body"
      return @model.attributes.more_info_body
    else if id == "company-splash-image"
      return @model.attributes.splash_image 
    else
      return ""

  editContent: (event) ->
    currentContent = @getContent $(event.currentTarget).attr("id")
    
  toggleEdit: (event) ->
    $(event.currentTarget).find(".company-edit-content").toggle()