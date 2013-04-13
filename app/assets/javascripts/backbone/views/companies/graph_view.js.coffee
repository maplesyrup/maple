class Maple.Views.CompaniesDashboardGraphView extends Backbone.View

  initialize: ->
    @render()

  render: ->
    # Render the template that contains
    # the #dashboard-graph DOM element
    # so we can render a d3 line graph
    # inside

    margin =
      top: 20,
      right: 20,
      bottom: 30,
      left: 50

    width = 960 - margin.left - margin.right
    height = 500 - margin.top - margin.bottom

    parseDate = d3.time.format("%d-%b-%y").parse

    x = d3.time.scale()
        .range([0, width])

    y = d3.scale.linear()
        .range([height, 0])

    xAxis = d3.svg.axis().scale(x)
        .orient("bottom").ticks(8)

    yAxis = d3.svg.axis().scale(y)
        .orient("left").ticks(5)

    area = d3.svg.area()
        .x (d) ->
          console.log(x(new Date(d.get("timestamp") * 1000)))
          return x(new Date(d.get("timestamp") * 1000))
        .y0(height)
        .y1 (d) ->
          return y(d.get("total_votes"))

    line = d3.svg.line()
        .x (d) ->
          return x(new Date(d.get("timestamp") * 1000))
        .y (d) ->
          return y(d.get("total_votes"))

    svg = d3.select(@el).append("svg")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
        .append("g")
          .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    x.domain(d3.extent @collection.models, (d) ->
      return new Date(d.get("timestamp") * 1000)
    )
    y.domain(d3.extent @collection.models, (d) ->
      return d.get("total_votes")
    )

    svg.append("path")
        .datum(@collection.models)
        .attr("class", "area")
        .attr("d", area)

    svg.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0," + height + ")")
        .call(xAxis)

    svg.append("g")
        .attr("class", "y axis")
        .call(yAxis)
        .append("text")
          .attr("transform", "rotate(-90")
          .attr("y", 6)
          .attr("dy", ".71em")
          .style("text-anchor", "end")

    svg.append("path")
      .datum(@collection.models)
      .attr("class", "line")
        .attr("d", line)

    @