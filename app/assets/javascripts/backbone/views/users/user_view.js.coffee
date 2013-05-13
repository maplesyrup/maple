class Maple.Views.UserView extends Backbone.View
  # Renders a View for a Single company. 

  template: JST["backbone/templates/users/user_thumb"]
  events:
    "click .follow-user-thumb" : "follow"

  initialize: ->
    @render()

  render: ->
    @$el.html(@template(_.extend(@model.toJSON(), Maple.session.toJSON())))
    @

  follow: (event) ->
    if Maple.session.get("user_signed_in")
      # user is signed in and wants to perform a follow
      target = $(event.currentTarget)
      if !_.contains(Maple.session.currentUser.get("users_im_following"), @model.id)
        # current user is not already following this user. Follow him!
        Maple.session.currentUser.get("users_im_following").push(@model.id)
        target.html("<button class='btn btn-success pull-right'>
                            Following
                            </button>")
      else
        # user is currently following this user. Unfollow
        Maple.session.currentUser.get("users_im_following").pop(@model.id)
        target.html("<button class='btn pull-right'>
                      <i class='icon-plus'></i> Follow 
                      </button>")

    Maple.session.currentUser.follow(
      type: "User"
      target: @model.id
      success:(count) ->
        console.log "number of users"
      error: (response) ->
        Maple.Utils.alert({ err: response })
      )

  close: ->
    @remove
    @unbind
    @.model.unbind
