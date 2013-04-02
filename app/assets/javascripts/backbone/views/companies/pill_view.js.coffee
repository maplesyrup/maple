class Maple.Views.CompaniesPillView extends Backbone.View
	
	tagName: 'li'
	
	className: 'company'

	template: JST['backbone/templates/companies/pill']

	initialize: ->
		@render()

	render: ->
	    @$el.html(@template(@model.toJSON()))
	    @