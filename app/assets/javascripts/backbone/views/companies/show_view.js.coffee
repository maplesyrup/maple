class Maple.Views.CompanyShowView extends Backbone.View
  # Display a company inside of
  # li.company DOM element.

  tagName: "div"

  className: "company"

  template: JST["backbone/templates/companies/show"]

  events:
    "focus [contenteditable]" : "editContent"
    "blur [contenteditable]" : "updateContent"
    "keyup [contenteditable]" : "stripContent"
    "click .follow" : "follow"
    "click .collection-filter" : "refilterCollection"
    "click #company-submit-logo" : "submitLogo"
    "click #company-submit-splash-image" : "submitSplash"
    "click .multiple-logo-image" : "selectLogo"

  initialize: ->
    @viewManager = new Maple.ViewManager()

    @model.on "change", =>
      if @model.hasChanged("logos")
        replaceImageTemplate = JST["backbone/templates/helpers/replace_image"]
        updatedLogo = @model.get("logos").filter (logo) ->
          return logo.selected
        @$el.find("#logo-placeholder").html(replaceImageTemplate({url: updatedLogo[0].medium}))

    $(window).scroll(@hideNav)
    Maple.mapleEvents.bind("campaignFilter", @campaignFilter)
    @render()

  render: ->
    @$el.html(@template(_.extend(@model.toJSON(), Maple.session.toJSON())))
    @populateCollection("company-posts")

    container = @$el.find(".campaign")
    view = new Maple.Views.CampaignShowView(
      model: @model
      collection: @model.campaigns
    )
    @viewManager.showView(view, container)

    @

  submitSplash: (event) ->
    event.preventDefault()
    event.stopPropagation()
    
    formData = new FormData($("#add-company-splash")[0])

    @model.savePaperclip(formData,
      type: 'PUT'
      success: (company) =>
        @model.set(company)
        $("#company-header-image").attr("src", @model.get("splash_image"))
        $("#uploadSplashModal").modal('hide')
      error: (xhr) =>
        Maple.Utils.alert({ err: xhr.status + ': ' + xhr.statusText }))
        
  selectLogo: (event) ->
    $(".selected").removeClass("selected")
    @selectedLogo = $(event.currentTarget)
    @selectedLogo.addClass("selected")

    @model.save(
      {logo_id: @selectedLogo.data("id")},
      {success: (company) =>
        $("#uploadLogoModal").modal('hide')
      error: (xhr) =>
        Maple.Utils.alert({ err: 'Unable to select logo'})})

  submitLogo: (event) ->
    event.preventDefault()
    event.stopPropagation()

    formData = new FormData($('#add-company-logo')[0])

    if ($("#upload-logo-field").val())
      @model.savePaperclip(formData,
        type: 'PUT'
        success: (company) =>
          @model.set(company)
          @render()
        error: (xhr) =>
          Maple.Utils.alert({ err: xhr.status + ': ' + xhr.statusText }))
    else
      Maple.Utils.alert({ err: 'You forgot to select a file.' })
    $("#uploadLogoModal").modal('hide')

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

  stripContent: (event) ->
    target = $(event.currentTarget)
    target.html(target.text())

  editContent: (event) ->
    event.stopPropagation()
    event.preventDefault()

    target = $(event.currentTarget)
    targetID = target.attr("id")
    if targetID == "company-splash-image"
      $("#uploadSplashModal").modal('show')
    else if targetID == "company-submit-logo"
      @submitLogo(event)
    else
      return false

  follow: (event) ->
    if Maple.session.get("user_signed_in")
      # user is signed in and wants to perform an action
      index = _.indexOf(Maple.session.currentUser.get("companies_im_following"), @model.id)
      if index == -1
        # user is not already following this company. Follow

        Maple.session.currentUser.get("companies_im_following").push(@model.id)
        $(".follow").html("<button class='btn btn-success pull-right'>
                            Following
                          </button>")
      else
        # user is currently following this company. Unfollow
        Maple.session.currentUser.get("companies_im_following").splice(index, 1)
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
        container = @$el.find("#company-posts-container")
        view = new Maple.Views.MultiColumnView(
          collection: @model.posts
          parent: "#company-posts-container"
          modelView: Maple.Views.PostView
          data:
            company_id: @model.id
        )
        @viewManager.showView(view, container)

      when "company-followers"
        container = @$el.find("#company-posts-container")
        view = new Maple.Views.MultiColumnView(
          collection: @model.followers
          parent: "#company-posts-container"
          modelView: Maple.Views.UserView
          data:
            followable_id: @model.id
            type: 'Company'
        )
        @viewManager.showView(view, container)

      else
        if collectionType.type == "campaign"
          container = @$el.find("#company-posts-container")
          view = new Maple.Views.MultiColumnView(
            collection: @model.posts.byCampaign(parseInt(collectionType.id))
            parent: "#company-posts-container"
            modelView: Maple.Views.PostView
            bootstrapped: true
            data:
              company_id: @model.id
          )
          @viewManager.showView(view, container)

        if collectionType.type == "reward"
          container = @$el.find("#company-posts-container")
          view = new Maple.Views.MultiColumnView(
            collection: @model.posts.byReward(parseInt(collectionType.id))
            parent: "#company-posts-container"
            modelView: Maple.Views.PostView
            bootstrapped: true
            data:
              company_id: @model.id
          )
          @viewManager.showView(view, container)

  hideNav: ->
    if $(window).scrollTop() < $("#company-header-image").height()
      $(".scroll-hide").css("display", "visible").fadeIn("slow")
    else if $(".scroll-hide").is(":visible")
      $(".scroll-hide").css("display", "hidden").fadeOut("slow")

  campaignFilter: (event) =>
    @populateCollection(event)

  refilterCollection: (event) ->
    event.stopPropagation()
    event.preventDefault()

    target = $(event.target)
    collectionType = target.attr("id")

    $(event.currentTarget).find(".active").removeClass("active")
    $(event.target).addClass("active")

    @populateCollection(collectionType)

  close: ->
    Maple.mapleEvents.unbind("campaignFilter")
    @model.off("change")
    $(window).unbind('scroll')
    @remove()
    @unbind()
    @viewManager.closeAll()

