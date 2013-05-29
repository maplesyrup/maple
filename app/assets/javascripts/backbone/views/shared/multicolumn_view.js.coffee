class Maple.Views.MultiColumnView extends Backbone.View
  # Associates the current View with
  # the #posts DOM element.
  # For every Post in the Collection,
  # render a Post View and append the
  # it to one of the four columns
  # DOM elements, #col1, #col2, #col3,
  # or #col4.

  id: "posts"

  parent: window

  className: "row glimpses "

  columnIds: ["#col1", "#col2", "#col3", "#col4", "#col5", "#col6"]

  numberOfColumns:      0

  postWidth:             270 # post width is 250, margin of 20px

  threeColumnTemplate:  JST["backbone/templates/shared/three_column_index"]
  fourColumnTemplate:   JST["backbone/templates/shared/four_column_index"]
  fiveColumnTemplate:   JST["backbone/templates/shared/five_column_index"]
  sixColumnTemplate:    JST["backbone/templates/shared/six_column_index"]

  template: ""

  events:
    "load" : "recalculateColumns"
    "click .load-posts" : "onLoadModels"

  initialize: ->
    @.collection.bind 'reset', =>
      @.render()
      @.addAll()

    @.collection.on 'add', (model) =>
      @addOne(model, @collection.indexOf(model))

    @collection.on 'remove', (model) =>
      model.destroy()
      @render()
      @addAll()

    @data = (@options.data || {})

    @collection.on 'change', (model) =>
      if @data.company_id != model.company_id
        # Remove the model from the collection if we're looking at company view
        # Keep silent so we don't trigger a remove event that actually removes model
        @collection.remove(model, { silent: true })
      @render()
      @addAll()

    @parent = @options.parent || window
    @modelView = @options.modelView

    @loading = false

    _.defaults(@data, {
      page: if @options.bootstrapped then 2 else 1,
      sort:
        by: 'total_votes'
    })

    @collection.comparator = (post) =>
      post.get(@data.sort.by)

    $(window).resize @recalculateColumns

    @recalculateColumns()

    if (!@options.bootstrapped)
      @loadModels()

  addAll: ->
    @collection.forEach(@addOne, @)

  addOne: (model, index) ->
    colId = @.getColumnId(index)

    @view = new @modelView({ model: model, collection: @collection })
    @$el.find(colId).append @view.render().el

  getColumnId: (index) ->
    @columnIds[index % @numberOfColumns]

  onLoadModels: (e) =>
    return if ($(e.target).hasClass('disabled')) || @loading

    @loadModels()


  loadModels: () =>
    @loading = true

    prevLength = @collection.length
    @collection.fetch
      data: $.param(@data)
      remove: false
      update: true
      add: true
      success: (collection) =>
        @loading = false
        @data.page += 1
        # If collection has no new models disable button
        if (collection.length == prevLength)
          @$el.find('.load-posts').addClass('disabled')
      error: (collection, xhr, options) =>
        @loading = false
        Maple.Utils.alert({ err: xhr.status + ': ' + xhr.statusText })


  recalculateColumns: =>
    width = $(@parent).width()
    columnsThatFit = Math.floor width/@postWidth
    switch columnsThatFit
      when 4
        if @numberOfColumns != 4
          @$el.width(4 * (@postWidth))
          @numberOfColumns = 4
          @template = @fourColumnTemplate
          @render()
          @addAll()
      when 5
        if @numberOfColumns != 5
          @$el.width(5 * (@postWidth))
          @numberOfColumns = 5
          @template = @fiveColumnTemplate
          @render()
          @addAll()
      when 6
        if @numberOfColumns != 6
          @$el.width(6 * (@postWidth))
          @numberOfColumns = 6
          @template = @sixColumnTemplate
          @render()
          @addAll()
      else
        if @numberOfColumns != 3
          @$el.width(3 * (@postWidth))
          @numberOfColumns = 3
          @template = @threeColumnTemplate
          @render()
          @addAll()

  render: ->
    @$el.html @template()
    @

  close: ->
    @collection.off()
    @remove
    @unbind
