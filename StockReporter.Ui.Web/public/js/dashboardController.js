angular.module('portfolioBooster.controllers',[])
.controller('dashboardController', function($scope,$http, MyStocksSummaryData, myShares, Reports, sharedServices){
  setMySharesSummaryReport($scope, MyStocksSummaryData);
  setDailyPerformersReport($scope, Reports);


  if (isLoggedIn()){

  sharedServices.latestDate.then(function(date){
    $scope.selectedDate = new Date(date);
    console.log($scope.selectedDate);
    $scope.GetDailyPerformers($scope.selectedDate);
  });

    $scope.getMySharesSummaryReport();
    getMySharesDitributionReport($scope, myShares);
  }
});

function setDailyPerformersReport(scope, reports){

  scope.GetDailyPerformers = function(date){

    if (!isLoggedIn()) {
      return;
    }

    reports.getReport(date, "DailyBottomPerformersReport")
    .success(function(data){
      scope.bottomPerformers = data.Rows;
      console.log(data.Rows);
    })
    .error(function(error){
      alert('Oh no, something went wrong while retrieving the top performers report. Please try again or contact us for help');
    });

    reports.getReport(date, "DailyTopPerformersReport")
    .success(function(data){
      scope.topPerformers = data.Rows;
      console.log(data.Rows);
    })
    .error(function(error){
      alert('Oh no, something went wrong while retrieving the top performers report. Please try again or contact us for help');
    });
  };
}

function setMySharesSummaryReport(scope, myStocksSummaryDataService){

  scope.getMySharesSummaryReport = function(){
    var date = new Date();
    var userId = window.localStorage['userId'];

    if (!isLoggedIn()) {
      return;
    }

    myStocksSummaryDataService.getReport(date)
    .success(function(data){
      scope.MyStocksSummary = data.Rows[0];
      console.log(data);
    })
    .error(function(error){
      alert('Oh no, something went wrong while retrieving the summary data. Please try again or contact us for help');
    })
  };
}

function getMySharesDitributionReport(scope, myShares){
       var date = getLatestMarketOpenDate();

       myShares.getReport(date)
       .success(function(data){
         var rows = data.Rows;
         var shares = [];

         _.each(rows, function(row){

           var shareIndex = row.ShareIndex;
           var existing = _.find(shares, function(item){
             return item.shareIndex == shareIndex;
           });

           if (existing == undefined){
             shares.push({shareIndex : row.ShareIndex, percentage : row.PercentageOfPortfolio});
           }else{
             existing.percentage = Math.round(existing.percentage + row.PercentageOfPortfolio);
           }
         });

         var shareValues = shares.map(function(row){return row.percentage;})
         var shareIndexes = shares.map(function(row){return row.shareIndex; })

         scope.portfolioDistributionData  = shareValues;
         scope.portfolioDistributionLabels = shareIndexes;
       })
       .error(function(error){
       });
}


function setMyPortfolioDistributionChart(scope, myShares){
       scope.portfolioDistributionLabels =["N/A"];
       scope.portfolioDistributionData = [1]; 
       scope.portfolioDistributionChartOptions = {
         datasetFill:false, 
         animation:false,
         showScale:true
       };

       getMySharesDitributionReport(scope, myShares);
}

function isLoggedIn(){ 
  var userId = window.localStorage['userId'];

  var isLoggedIn = (userId  != 'undefined' && userId != "");

  console.log('is logged in' + isLoggedIn);

  return isLoggedIn;
}
