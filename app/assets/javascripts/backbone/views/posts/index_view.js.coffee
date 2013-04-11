class Maple.Views.PostsIndexView extends Backbone.View
  # Associates the current View with
  # the #posts DOM element.
  # For every Post in the Collection,
  # render a Post View and append the
  # it to one of the four columns
  # DOM elements, #col1, #col2, #col3,
  # or #col4.

  id: "posts"

  className: "row glimpses "
  
  columnIds: ["#col1", "#col2", "#col3", "#col4", "#col5"]

  min_number_of_columns:  3
  max_number_of_columns:  5 
  number_of_columns:      0

  post_width:             275

  three_column_template:  JST["backbone/templates/posts/three_column_index"]
  four_column_template:   JST["backbone/templates/posts/four_column_index"]
  five_column_template:   JST["backbone/templates/posts/five_column_index"]
     
  template: "" 

  initialize: ->
    @.collection.bind 'reset', =>
      @.render()
      @.addAll()

    @.collection.on 'add', (model) =>
      @addOne(model, @collection.length - 1)  

    $(window).resize @recalculateColumns

    @recalculateColumns()

  addAll: ->
    @collection.forEach(@addOne, @)

  addOne: (model, index) ->
    colId = @.getColumnId(index)
    @view = new Maple.Views.PostView({ model: model })
    @$el.find(colId).append @view.render().el

  getColumnId: (index) ->
    @columnIds[index % @number_of_columns]

  recalculateColumns: =>
    width = @$el.parent().innerWidth() || window.innerWidth   
    columns_that_fit = Math.floor width/@post_width
    switch columns_that_fit
      when 3 
        if @number_of_columns != 3
          @number_of_columns = 3
          @template = @three_column_template
          @render()
          @addAll()
      when 4 
        if @number_of_columns != 4
          @number_of_columns = 4
          @template = @four_column_template
          @render()
          @addAll()
      when 5
        if @number_of_columns != 5
          @number_of_columns = 5
          @template = @five_column_template
          @render()
          @addAll()        

  render: ->
    @$el.html @template()
    @

  close: ->
    @remove
    @unbind
