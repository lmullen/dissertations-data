var viz = d3.select("#viz").append("svg");

nv.addGraph(function() {
  var chart = nv.models.scatterChart()
  .showDistX(true)
  .showDistY(true)
  .color(d3.scale.category10().range());

  chart.xAxis.tickFormat(d3.format('.02f'));
  chart.yAxis.tickFormat(d3.format('.02f'));

  viz
  .datum(data(3,20))
  .transition().duration(500)
  .call(chart);

  nv.utils.windowResize(chart.update);

  return chart;
});


data = function(groups, points) {
  var data = [],
  shapes = ['circle', 'cross', 'triangle-up', 'triangle-down', 'diamond', 'square'],
  random = d3.random.normal();

  for (i = 0; i < groups; i++) {
    data.push({
      key: 'Group ' + i,
      values: []
    });

    for (j = 0; j < points; j++) {
      data[i].values.push({
        x: random()
      , y: random()
      , size: Math.random()
    //, shape: shapes[j % 6]
      });
    }
  }

  return data;
}

