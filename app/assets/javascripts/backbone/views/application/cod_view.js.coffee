class Maple.Views.CodView extends Backbone.View

  template: JST["backbone/templates/application/cod"]

  initialize: (options) ->
    stats = {
      lastWeek: {}
      thisWeek: {}
    }
    companies = new Maple.Collections.CompaniesCollection()
    #posts = new Maple.Collections.PostsCollection()
    #users = new Maple.Collections.UsersCollection()
    #campaigns = new Maple.Collections.CampaignsCollection()

    companies.fetch(
      async: false
      processData: true
      data:
        startDate:
        endDate:
      success: (companies) ->
        console.log(companies)
    )


    @render()
    @

  render: ->
    @$el.html @template()
    @
