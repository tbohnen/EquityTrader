angular.module('portfolioBooster.controllers')
    .controller('chartsController', function($scope, ChartData) {

        $scope.refresh = function(shareIndex, startDate, endDate, chart){
            ChartData.chartData(shareIndex,startDate, endDate,chart).error(function(){
                alert('Ugh, something went wrong with loading the chart. Please try again or contact us for support.');
            })
                .success(function(data){

                    var mappedData = $.map(data.Rows, function(d, i){
                        console.log(d);
                        console.log(i);
                        var open = +d.closePrice/100;
                        if (i > 0){
                            open = data.Rows[i-1].closePrice/100;
                        }
                        return {
                            date: new Date(d.dateOfPrice),
                            open: open,
                            close: +d.closePrice/100,
                            high: +d.highPrice/100,
                            low: +d.lowPrice/100,
                            volume: +d.volume
                        };

                    });
                    console.log(mappedData);

                    getChartData(mappedData);
                });
        };

    });



function getChartData(data){
      var margin = {top: 20, right: 20, bottom: 30, left: 50},
      width = 960 - margin.left - margin.right,
      height = 500 - margin.top - margin.bottom;
      var parseDate = d3.time.format("%d-%b-%y").parse;
      var x = techan.scale.financetime()
      .range([0, width]);
      var y = d3.scale.linear()
      .range([height, 0]);
      var candlestick = techan.plot.candlestick()
      .xScale(x)
      .yScale(y);
      var xAxis = d3.svg.axis()
      .scale(x)
      .orient("bottom");
      var yAxis = d3.svg.axis()
      .scale(y)
      .orient("left");
      var svg = d3.select("#page-wrapper").append("svg")
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
      .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
      var accessor = candlestick.accessor(),
      timestart = Date.now();
    data = data.sort(function(a, b) { return d3.ascending(accessor.d(a), accessor.d(b)); });
      x.domain(data.map(accessor.d));
      y.domain(techan.scale.plot.ohlc(data, accessor).domain());
      svg.append("g")
      .datum(data)
      .attr("class", "candlestick")
      .call(candlestick);
      svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + height + ")")
      .call(xAxis);
      svg.append("g")
      .attr("class", "y axis")
      .call(yAxis)
      .append("text")
      .attr("transform", "rotate(-90)")
      .attr("y", 6)
      .attr("dy", ".71em")
      .style("text-anchor", "end")
      .text("Price (R)");
      console.log("Render time: " + (Date.now()-timestart));
}
