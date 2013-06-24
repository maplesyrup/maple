# User Profile Page
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
    "click #user-submit-avatar" : "submitAvatar"

  initialize: ->
    @viewManager = new Maple.ViewManager()
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

    target = $(event.target)
    targetID = target.attr("id")
    if targetID == "user-avatar-container"
      $("#userAvatarModal").modal('show')
    else
      return false
  
  submitAvatar: (event) ->
    $(".spinner").toggle()

    event.preventDefault()
    event.stopPropagation()
    
    formData = new FormData($("#new-user-avatar")[0])

    @model.savePaperclip(formData,
      type: 'PUT'
      success: (user) =>
        @model.set(user)
        $("#avatar").attr("src", @model.get("avatar"))
        $("#userAvatarModal").modal('hide')
        $(".spinner").toggle()
      error: (xhr) =>
        $(".spinner").toggle()
        Maple.Utils.alert({ err: xhr.status + ': ' + xhr.statusText })
    )
 
  populateCollection: (collectionType) ->
    switch collectionType
      when "user-posts"
        container = @$el.find("#user-main-container")
        view = new Maple.Views.MultiColumnView(
          collection: @model.posts
          parent: "#user-main-container"
          modelView: Maple.Views.PostView
          data:
            user_id: @model.id
        )
        @viewManager.showView(view, container)

      when "user-following-companies"
        container = @$el.find("#user-main-container")
        view = new Maple.Views.MultiColumnView(
          collection: @model.companies_following
          parent: "#user-main-container"
          modelView: Maple.Views.CompanyView
          data:
            follower: @model.id
        )
        @viewManager.showView(view, container)

      when "user-following-users"
        container = @$el.find("#user-main-container")
        view = new Maple.Views.MultiColumnView(
          collection: @model.users_following
          parent: "#user-main-container"
          modelView: Maple.Views.UserView
          data:
            follower: @model.id
        )
        @viewManager.showView(view, container)

      when "user-followers"
        container = @$el.find("#user-main-container")
        view = new Maple.Views.MultiColumnView(
          collection: @model.followers
          parent: "#user-main-container"
          modelView: Maple.Views.UserView
          data:
            followable_id: @model.id
            type: 'User'
        )
        @viewManager.showView(view, container)

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

  close: ->
    @viewManager.closeAll()
    @remove()
    @unbind()
