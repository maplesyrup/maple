class Maple.Views.CompaniesIndexView extends Backbone.View
  # Associate the current View with
  # the .companies DOM element.
  # For every Company inside of the
  # Collection, render a Company View
  # and append it to the end of the
  # .companies DOM element.

  el: "#discover-companies"

  listEl: "#discover-companies-list"

  searchEl: "#discover-companies-search"

  template: JST["backbone/templates/companies/index"]

  events:
    "keyup #discover-companies-search" : "filter"

  initialize: ->
    @filteredCollection = @collection
    $("#find-companies").live "click", =>
      @$el.toggle("1000")
    @render()
    @addAll()

  addAll: ->
    $(@listEl).html("")
    @filteredCollection.forEach(@addOne, @)

  addOne: (model, index) ->
    @view = new Maple.Views.CompaniesPillView({ model: model })
     
    $(@listEl).append @view.render().el

  render: ->
    @$el.html @template()
    @

  filter: (e) ->
    query = $(@searchEl).val()
    @filteredCollection = @collection.search(query)
    @addAll()

  close: ->
    @unbind()
    $("#find-companies").die("click")
    @$el.html("")  
        
