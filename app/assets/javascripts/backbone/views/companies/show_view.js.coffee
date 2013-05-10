class Maple.Views.CompanyShowView extends Backbone.View
  # Display a company inside of
  # li.company DOM element.

  tagName: "div"

  className: "company"

  template: JST["backbone/templates/companies/show"]

  events:
    "focus [contenteditable]" : "editContent"
    "blur [contenteditable]" : "updateContent"
    "click .follow" : "follow"
    "click .collection-filter" : "refilterCollection"
    "click #company-submit-logo" : "submitLogo"

  initialize: ->
    @model.on "change", =>
      if @model.hasChanged("logos")
        replaceImageTemplate = JST["backbone/templates/helpers/replace_image"]
        @$el.find("#logo-placeholder").html(replaceImageTemplate({url: @model.get("logos")[@model.get("logos").length - 1].medium}))

    @render()

  render: ->
    @$el.html(@template(_.extend(@model.toJSON(), Maple.session.toJSON())))
    @populateCollection("company-posts")
    @

  submitLogo: (event) ->
    event.preventDefault()
    event.stopPropagation()

    formData = new FormData($('#add-company-logo')[0])

    @model.savePaperclip(formData,
      type: 'PUT'
      success: (company) =>
        @model.set(company)
        $("#uploadLogoModal").modal('hide')
      error: (xhr) =>
        Maple.Utils.alert({ err: xhr.status + ': ' + xhr.statusText }))

  saveContent: (id, content) ->
    if id ==  "company-blurb-title"
      @model.set({ blurb_title: content })
    else if id == "company-blurb-body"
      @model.set({ blurb_body: content })
    else if id == "company-more-info-title"
      @model.set({ more_info_title: content })
    else if id == "company-more-info-body"
      @model.set({ more_info_body: content })
    else if id == "company-logo-field"
      @model.set({ logo: content })
    else if id == "company-splash-image"
      @model.set({ splash_image: content})
    else
      return false

    @model.patch(
      ["blurb_title",
      "blurb_body",
      "more_info_title",
      "more_info_body"])

  updateContent: (event) ->
    target = $(event.currentTarget)
    targetID = target.attr("id")
    @saveContent(targetID, target.html())

  editContent: (event) ->
    event.stopPropagation()
    event.preventDefault()

    target = $(event.currentTarget)
    targetID = target.attr("id")
    if targetID == "company-header-image"
      @$el.find("#company-select-new-image").html( new Maple.Views.UploadImageView({ model: @model, inputName: "company[splash_image]", targetImgContainer: "#company-header-image", resourceName: "splash_image"}).el)
    else if targetID == "company-submit-logo"
      @submitLogo(event)
    else
      return false

  follow: (event) ->
    if Maple.session.get("user_signed_in")
      # user is signed in and wants to perform an action
      if !_.contains(Maple.session.currentUser.get("companies_im_following"), @model.id)
        # user is not already following this company. Follow

        Maple.session.currentUser.get("companies_im_following").push(@model.id)
        $(".follow").html("<button class='btn btn-success pull-right'>
                            Following
                          </button>")
      else
        # user is currently following this company. Unfollow
        Maple.session.currentUser.get("companies_im_following").pop(@model.id)
        $(".follow").html("<button class='btn pull-right'>
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

  populateCollection: (collectionType) ->
    switch collectionType
      when "company-posts"
        @$el.find("#company-posts-container").html new Maple.Views.MultiColumnView(
          collection: @model.posts
          parent: "#company-posts-container"
          modelView: Maple.Views.PostView
          data:
            company_id: @model.id
        ).el

      when "company-followers"
        @$el.find("#company-posts-container").html new Maple.Views.MultiColumnView(
          collection: @model.followers
          parent: "#company-posts-container"
          modelView: Maple.Views.UserView
          data:
            followable_id: @model.id
            type: 'Company'
        ).el

  refilterCollection: (event) ->
    event.stopPropagation()
    event.preventDefault()

    target = $(event.target)
    collectionType = target.attr("id")

    $(event.currentTarget).find(".active").removeClass("active")
    $(event.target).addClass("active")

    @populateCollection(collectionType)

