// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
var posts_js_controller =
{
	history_started: false,

	getCompanies: function(_url)
	{
		$.ajax(
		{
			type: "GET",
			url: _url,
			dataType: "json",
			success: function(data) 
			{
				console.log(data);
				window.router = new Maple.Routers.PostsRouter({ posts: data});
				if (!posts_js_controller.history_started)
				{
					Backbone.history.start();
					posts_js_controller.history_started = true;
				}
			},
			error: function() 
			{
				console.log("We have an error");
			}
		});
	},

	routeFilter: function(event)
	{
		posts_js_controller.getCompanies(event.target.getAttribute("filter"));
	}
}

$(function()
{
	$(".company-listing").bind("click", posts_js_controller.routeFilter);
	posts_js_controller.getCompanies("posts/all");
});
