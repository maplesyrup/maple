class Maple.Views.CompanyView extends Backbone.View
  # Renders a View for a Single company.

  template: JST["backbone/templates/companies/company_thumb"]

  events:
    "click .vote": "vote"

  initialize: ->
    @.model.bind 'change', =>
      if(@.model.hasChanged('total_votes'))
        @.render()

  vote: ->
    num_votes = @.model.get('total_votes')

    $.ajax
      type: "POST"
      url: "/posts/vote_up"
      data: "post_id=" + @.model.get('id')
      success: =>
        console.log("Success")
      error: (xhr) =>
        Maple.Utils.alert({ err: xhr.status + ': ' + xhr.statusText })

    @.model.set({'total_votes': num_votes + 1, 'voted_on': Maple.Post.VOTED.YES})

  render: ->
    @$el.html(@template(@model.toJSON()))
    @

  close: ->
    @remove
    @unbind
    @.model.unbind
