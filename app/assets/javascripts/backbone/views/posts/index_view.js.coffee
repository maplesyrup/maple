class Maple.Views.PostsIndexView extends Backbone.View
  # Associates the current View with
  # the #posts DOM element.
  # For every Post in the Collection,
  # render a Post View and append the
  # it to one of the four columns
  # DOM elements, #col1, #col2, #col3,
  # or #col4.

  id: "posts"

  className: "row glimpses"
  
  columnIds: ["#col1", "#col2", "#col3", "#col4"]

  template: JST["backbone/templates/posts/index"]

  initialize: ->
    @.collection.bind 'reset', =>
      @.render()
      @.addAll()

    @.collection.on 'add', (model) =>
      @addOne(model, @collection.length - 1)  

    @render()
    @addAll()

  addAll: ->
    @collection.forEach(@addOne, @)

  addOne: (model, index) ->
    colId = @.getColumnId(index)
    @view = new Maple.Views.PostView({ model: model })
    @$el.find(colId).append @view.render().el

  getColumnId: (index) ->
    @columnIds[index % @columnIds.length]

  render: ->
    @$el.html @template()
    @

  close: ->
    @remove
    @unbind
