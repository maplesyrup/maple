class Maple.Views.CompaniesDashboardView extends Backbone.View
  # Display the current company's
  # dashboard

  tagName: "div"

  className: "dashboard"

  template: JST["backbone/templates/companies/dashboard/dashboard"]

  initialize: ->
    @render()

  render: ->
    @$el.html(@template(@model.toJSON()))
    ordered_posts = @model.posts.order_by_created_at()
    @model.posts.fetch
      data:
        company_id: @model.id
      success: =>
        @$el.find("#dashboard-graph").html(new Maple.Views.CompaniesDashboardGraphView({ collection: ordered_posts }).el)
        @$el.find("#dashboard-stats").html(new Maple.Views.CompaniesStatsView({ collection: ordered_posts }).el)
    @