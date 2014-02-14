var width = 800;
var height = 500;

var viz = d3.select("#viz")
.append("svg")
.attr("width", width)
.attr("height", height);

queue()
.defer(d3.csv, "h_diss2_web.csv")
.await(main);

function main(error, pages_data) {

  var scale_x = d3.scale.linear()
  .domain([1950, 2012])
  .range([0, width]);

  var axis_x = d3.svg.axis()
  .scale(scale_x)
  .orient("bottom")
  .ticks(10);

  var scale_y = d3.scale.linear()
  .domain([0, d3.max(pages_data, function(d) {return +d.pages})])
  .range([height, 0]);

  var axis_x = d3.svg.axis()
  .scale(scale_y)
  .orient("left")
  .ticks(10);

  viz.selectAll("circle")
  .data(pages_data)
  .enter()
  .append("circle")
  .attr("class", "diss-point")
  .attr("cx", function(d) {
    return scale_x(+d.year);
  })
  .attr("cy", function(d) {
    return scale_y(+d.pages);
  })
  .attr("r", 5);

  viz.append("g")
  .attr("class", "x axis")
  .call(axis_x)
  .attr("transform", "translate(" + (chart_width + 1) + ",0)")

};

