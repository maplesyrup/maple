class Maple.Views.CompanyView extends Backbone.View
  # Renders a View for a Single company.

  template: JST["backbone/templates/companies/company_thumb"]

  events:
    "click .follow-company-thumb": "follow"
    "mouseover" : "onMouseover"
    "mouseout" : "onMouseout"

  initialize: ->
    @render()

  render: ->
    @$el.html(@template(_.extend(@model.toJSON(), Maple.session.toJSON())))
    @

  onMouseover: (e) =>
    @$el.find('.outer-feature').css 'visibility', 'visible'
    @$el.find('.header-feature').css 'visibility', 'visible'

  onMouseout: (e) =>
    @$el.find('.outer-feature').css 'visibility', 'hidden'
    @$el.find('.header-feature').css 'visibility', 'hidden'

  close: ->
    @remove
    @unbind
    @.model.unbind
  
  follow: (event) ->
    if Maple.session.get("user_signed_in")
      # user is signed in and wants to perform an action
      target = $(event.currentTarget)
      index = _.indexOf(Maple.session.currentUser.get("companies_im_following"), @model.id)
      if index == -1
        # user is not already following this company. Follow

        Maple.session.currentUser.get("companies_im_following").push(@model.id)
        target.html("<button class='btn btn-success pull-right'>
                            Following
                          </button>")
      else
        # user is currently following this company. Unfollow
        Maple.session.currentUser.get("companies_im_following").splice(index, 1)
        target.html("<button class='btn pull-right'>
                            <i class='icon-plus'></i> Follow
                          </button>")

      Maple.session.currentUser.follow(
        type: "Company"
        target: @model.id
        success:(count) ->
          console.log "number of users"
        error: (response) ->
          Maple.Utils.alert({ err: response })
        )


