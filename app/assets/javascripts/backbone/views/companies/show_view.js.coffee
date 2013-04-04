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

  editContent: (event) ->
    console.log $(event.currentTarget).data

  toggleEdit: (event) ->
    $(event.currentTarget).find(".company-edit-content").toggle()