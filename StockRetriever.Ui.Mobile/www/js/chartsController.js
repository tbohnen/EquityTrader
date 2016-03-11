angular.module('starter.controllers')
.controller('ChartsCtrl', function($scope,ChartData, $ionicLoading){

  $scope.labels = [];
  $scope.series = [''];
  $scope.chartOptions = {
    datasetFill:false, 
    animation:false,
    showScale:true,
    scaleShowGridLines: true,
    pointDot:false, 
    bezierCurve:false
  };

  $scope.startDate = moment().subtract(30, 'days').toDate();
  $scope.endDate = new Date();
  var showMonthXLabels = false;

  $scope.getChart = function(shareIndex, startDate, endDate,report) {

    $ionicLoading.show({template: "loading..."});

    ChartData.chartData(shareIndex, startDate, endDate, report)
    .error(function(){
      alert('Ugh, something went wrong with loading the chart. Please try again or contact us for support.');
      $ionicLoading.hide();
    })
    .success(function(data){
      $ionicLoading.hide();
      var results = [];
      for (var i = 0; i < data.Rows.length; i++){
        results.push(data.Rows[i]);
      }

      //TODO: Eish, figure out a way to do this better!!!
      if (results.length > 20) {
        showMonthXLabels = true; 
      }
      else{
        showMonthXLabels = false;
      }

      var fillColor = "rgba(252,7,31,0)";
      var datasets = [];
      if (report == "MyPortfolioReport"){
        var portfolioOverallValues = results.map(function(row){return row.portfolioOverallValue/100;})

        var labels = results.map(function(row){
          if (showMonthXLabels){
            return showFirstDateOfMonthOrNothing(new Date(row.date));
          }
          else return toJSONLocal(new Date(row.date));
        });

        $scope.labels = labels;
        $scope.series = ['Portfolio Value'];
        $scope.data = [portfolioOverallValues];

      }

      if (report == "RsiReport"){
        var labels = results.map(function(row){
          if (showMonthXLabels){
            return showFirstDateOfMonthOrNothing(new Date(row.date));
          }
          else return toJSONLocal(new Date(row.date));
        });

        var rsi = results.map(function(row){ return parseInt(row.rsi);});

        $scope.labels = labels;
        $scope.series = ['Relative Strength'];
        $scope.data = [rsi];
      }

      if (report == "SingleStockMacdReport"){

        var labels = results.map(function(row){
          if (showMonthXLabels){
            return showFirstDateOfMonthOrNothing(new Date(row.date));
          }
          else return toJSONLocal(new Date(row.date));
        });

        macd = results.map(function(row){ return parseInt(row.macd_line);});
        histogram = results.map(function(row){ return parseInt(row.histogram);});
        divergence = results.map(function(row){ return parseInt(row.signal_line);});

        $scope.labels = labels;
        $scope.series = ['Macd','Divergence'];
        $scope.data = [macd,divergence];
      }

      if (report == "DailyCloseStockPriceReport"){

        var labels = results.map(function(row){
          if (showMonthXLabels){
            return showFirstDateOfMonthOrNothing(new Date(row.dateOfPrice));
          }
          else return toJSONLocal(new Date(row.dateOfPrice));
        });


        close_prices = results.map(function(row){return row.closePrice / 100;})

        $scope.labels = labels;
        $scope.data = [close_prices]
        $scope.series = ['Close Prices']
      }

    });
  };
});


var lastDate = undefined;
var dateCount = 0;

function showFirstDateOfMonthOrNothing(date){
  var returnValue = "";
  if (dateCount == 0){
    returnValue = toJSONLocal(date);
  }
  else if (dateCount % 10 == 0){
    returnValue = toJSONLocal(date);
  }

  dateCount ++;
  return returnValue;
}
