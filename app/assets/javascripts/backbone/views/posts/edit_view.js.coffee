class Maple.Views.EditPostView extends Backbone.View

  id: 'editPost'

  tagName: 'div'

  template: JST["backbone/templates/posts/edit"]

  campaignTemplate: JST["backbone/templates/campaigns/edit-select-list"]

  events:
    'click #post-submit' : 'save'

  initialize: (options) ->
    @submitLocked = false
    @companies =  options.companies
    @company = options.company

    @render()

    @$el.find("#company").change(@loadCampaigns)

    @loadCampaigns()

  render: ->
    @$el.html @template(_.extend(
      companies:
        @companies && @companies.toJSON()
      company:
        @company && @company.toJSON()
      post:
        @model.toJSON()
        ))
    @

  save: (e) =>
    if !@submitLocked
      e.preventDefault()
      e.stopPropagation()

      data = @$el.find('#edit-post').serializeArray()
      attributes = {}

      data.forEach((datum) =>
        attributes[datum.name] = datum.value)

      unless attributes['campaign_id']
        attributes['campaign_id'] = null

      $(".spinner").toggle()
      @submitLocked = true
      
      @model.set(attributes)

      @model.patch(_.keys(attributes),
        success: (post) =>

          @submitLocked = false
          $(".spinner").toggle()

          $("#mainModal").modal('hide')
          window.router.navigate('/posts/' + post.id, { trigger: true })
        error: (post, response, options) =>
          @submitLocked = false
          $(".spinner").toggle()
          $("#mainModal").modal('hide')
          Maple.Utils.alert({ err: response.status + ': ' + response.statusText }))

  loadCampaigns: (event) =>
    company_id = @$el.find("#company").val()
    @companies.get(company_id).campaigns.fetch(
      success:(event) =>
        @$el.find("#campaign-select").html @campaignTemplate(
          campaigns: event
        )
        console.log(event)
      error:(collection, response, options) ->
        Maple.Utils.alert({ err: response.status + ': ' + response.statusText })
      data:
        company_id: company_id
    )

  validate: (e) =>
    console.log(e)

  close: =>
    @$el.remove()
    @unbind()
