class Maple.Views.UserShowView extends Backbone.View

  tagName: 'div'

  className: 'company'

  template: JST["backbone/templates/users/show"]

  events:
    "blur [contenteditable]" : "updateContent"
    "focus [contenteditable]": "editContent"
    "click .collection-filter" : "refilterCollection"
    "click .follow" : "follow"
    "click .delete-user" : "onDeleteUser"

  initialize: ->
    @render()

  render: ->
    @$el.html(@template(_.extend(@model.toJSON(), Maple.session.toJSON())))
    @populateCollection("user-posts")
    @

  onDeleteUser: (event) =>
    confirmDelete = confirm("Are you sure you want to delete your account?")

    if (confirmDelete)
      @model.destroy()

      # For now this is necessary because we don't use backbone for the header,
      # thus we need to refresh the whole page :/
      window.location.href = '/'

  saveContent: (id, content) ->
    if id ==  "personal-info"
      @model.set({ personal_info: content })
    else
      return false

    @model.patch(
      ["personal_info"])

  updateContent: (event) ->
    target = $(event.currentTarget)
    targetID = target.attr("id")
    @saveContent(targetID, target.html())

  editContent: (event) ->
    event.stopPropagation()
    event.preventDefault()

    target = $(event.currentTarget)
    targetID = target.attr("id")
    if targetID == "avatar"
      @$el.find("#user-select-new-avatar").html(
        new Maple.Views.UploadImageView({
          model: @model,
          inputName: "user[avatar]",
          targetImgContainer: "#avatar",
          resourceName: "avatar"
        }).el)
    else
      return false

  populateCollection: (collectionType) ->
    switch collectionType
      when "user-posts"
        @$el.find("#user-main-container").html new Maple.Views.MultiColumnView(
          collection: @model.posts
          parent: "#user-main-container"
          modelView: Maple.Views.PostView
          data:
            user_id: @model.id
        ).el

      when "user-following-companies"
        @$el.find("#user-main-container").html new Maple.Views.MultiColumnView(
          collection: @model.companies_following
          parent: "#user-main-container"
          modelView: Maple.Views.CompanyView
          data:
            follower: @model.id
        ).el

      when "user-following-users"
        @$el.find("#user-main-container").html new Maple.Views.MultiColumnView(
          collection: @model.users_following
          parent: "#user-main-container"
          modelView: Maple.Views.UserView
          data:
            follower: @model.id
        ).el

      when "user-followers"
        @$el.find("#user-main-container").html new Maple.Views.MultiColumnView(
          collection: @model.followers
          parent: "#user-main-container"
          modelView: Maple.Views.UserView
          data:
            followable_id: @model.id
            type: 'User'
        ).el

  refilterCollection: (event) ->
    event.stopPropagation()
    event.preventDefault()

    target = $(event.target)
    collectionType = target.attr("id")

    $(".collection-filter").find(".active").removeClass("active")
    $(event.target).addClass("active")

    if collectionType == "user-following-companies"
      $(".following-type").html("Following Companies <span class='caret'></span>")
    else if collectionType == "user-following-users"
      $(".following-type").html("Following Users <span class='caret'></span>")
    else
      $(".following-type").html("Following <span class='caret'></span>")

    @populateCollection(collectionType)

  follow: (event) ->
    if Maple.session.get("user_signed_in")
      # user is signed in and wants to perform an action
      index = _.indexOf(Maple.session.currentUser.get("users_im_following"), @model.id) 
      if index == -1
        # user is not already following this user. Follow

        Maple.session.currentUser.get("users_im_following").push(@model.id)
        $(".follow").html("<button class='btn btn-success pull-right'>
                            Following
                          </button>")
      else
        # user is currently following this user. Unfollow
        Maple.session.currentUser.get("users_im_following").splice(index, 1)
        $(".follow").html("<button class='btn pull-right'>
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

