class Maple.Views.CompaniesDashboardView extends Backbone.View
  # Display the current company's
  # dashboard

  tagName: "div"

  className: "dashboard"

  template: JST["backbone/templates/dashboard/dashboard"]

  events:
    "change #filter-date": "filter"

  initialize: ->
    @options = @options || {}
    @options.startDate = Date.today().add(-7).days()
    @options.endDate = Date.today()
    @options.ordered_posts = @model.posts.order_by_created_at()

    @dashboardData = @dashboardData || {}



    @render()

  render: ->
    @$el.html(@template(@model.toJSON()))
    @model.posts.fetch
      data:
        company_id: @model.id
      success: =>
        @renderGraph()
        @renderStats()
      error: (model, xhr, options) =>
        Maple.Utils.alert({ err: xhr.status + ': ' + xhr.statusText })


    $.ajax({
      url: @model.url() + '/dashboard'
      success: (data) =>
        @dashboardData = data
        @renderSummary()
        @renderContributors()
      error: (xhr) ->
        Maple.Utils.alert({ err: xhr.status + ': ' + xhr.statusText })
    })

    @

  renderSummary: ->
    @$el.find("#summary").html(new Maple.Views.DashboardSummaryView({ collection: @dashboardData }).el)

  renderGraph: ->
    @$el.find("#dashboard-graph").html(new Maple.Views.CompaniesDashboardGraphView({ collection: @options.ordered_posts }).el)

  renderStats: ->
    @$el.find("#dashboard-stats").html(new Maple.Views.CompaniesStatsView({ collection: @options.ordered_posts }).el)

  renderContributors: ->
    @$el.find("#top-contributors").html(new Maple.Views.DashboardContributorsView({ collection: @dashboardData }).el)

  filter: (ev) ->
    dateRange = $(ev.target).find(':selected').data('range')
    if dateRange == 'week'
      @options.startDate = @options.endDate.add(-7).days()
    else
      @options.startDate = @options.endDate.add(-7).months()

    @renderGraph()
    @renderStats()
