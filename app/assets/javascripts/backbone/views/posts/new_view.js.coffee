class Maple.Views.NewPostView extends Backbone.View

  className: 'newPost'

  tagName: 'div'

  template: JST["backbone/templates/posts/new"]

  events:
    'click #post-submit' : 'save'

  initialize:(options) ->
    @companies =  options.companies
    @render()

  render: ->
    @$el.html @template({ companies: @companies.toJSON() })
    $("body").append @$el


  save: (e) =>
    e.preventDefault()
    e.stopPropagation()
    title = @$el.find('#post-title').val()
    content = @$el.find('#post-content').val()
    company_id = @$el.find('#post-company').val()

    model = new Maple.Models.Post({title: title, content: content, company_id: company_id})
    @collection.create model,
         success: (post) =>
           @model = post
           @close()
           window.location.hash = ""


  close: =>
    @remove()
    @unbind()



