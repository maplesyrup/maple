class Maple.Views.PostsIndexView extends Backbone.View

  el: "#posts"

  template: JST["backbone/templates/posts/index"]

  initialize: ->
    @render()
    @addAll()

  addAll: ->
    @collection.forEach(@addOne, @)

  addOne: (model, index) ->
    colId = @.getColumnId(index)
    @view = new Maple.Views.PostView({ model: model })
    @$el.find(colId).append @view.render().el

  getColumnId: (index) ->
    switch (index % 4)
      when 0 then return "#col1"
      when 1 then return "#col2"
      when 2 then return "#col3"
      when 3 then return "#col4"
      else return "#col1"

  render: ->
    @$el.html @template()
    @