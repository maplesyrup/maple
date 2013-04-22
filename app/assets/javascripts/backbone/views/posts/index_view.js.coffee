class Maple.Views.PostsIndexView extends Backbone.View
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

  postWidth:             295 # post width is 275, margin of 20px 

  threeColumnTemplate:  JST["backbone/templates/posts/three_column_index"]
  fourColumnTemplate:   JST["backbone/templates/posts/four_column_index"]
  fiveColumnTemplate:   JST["backbone/templates/posts/five_column_index"]
  sixColumnTemplate:    JST["backbone/templates/posts/six_column_index"]

  template: "" 

  events:
    "load" : "recalculateColumns"

  initialize: ->
    @.collection.bind 'reset', =>
      @.render()
      @.addAll()

    @.collection.on 'add', (model) =>
      @addOne(model, @collection.length - 1) 
    @parent = @options.parent || window
    $(window).resize @recalculateColumns

    @recalculateColumns()

  addAll: ->
    @collection.forEach(@addOne, @)

  addOne: (model, index) ->
    colId = @.getColumnId(index)
    @view = new Maple.Views.PostView({ model: model })
    @$el.find(colId).append @view.render().el

  getColumnId: (index) ->
    @columnIds[index % @numberOfColumns]

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
    @remove
    @unbind
