angular.module('starter.controllers')
.controller('DashboardCtrl', function($state,
                                      $scope,
                                      $http,
                                      $interval,
                                      RefreshData,
                                      MyStocksSummaryData,
                                      $cordovaOauth,
                                      UserProfile,
                                      MyShares,
                                      Reports,
                                      sharedServices){

  setState($scope);
  setOnEnter($scope, $state, MyShares);
  addGoogleLoginToScope($scope, UserProfile, MyShares);
  setMySharesSummaryReport($scope, MyStocksSummaryData);
  setMyPortfolioDistributionChart($scope, MyShares);
  setDailyPerformersReport($scope,Reports);

  $interval(function(){refreshDashboard($scope, MyShares)}, 1000000);


  sharedServices.latestDate.then(function(date){
    $scope.selectedDate = new Date(date);
    $scope.GetDailyPerformers($scope.selectedDate);
  });

  refreshDashboard($scope, MyShares);

});

function setMyPortfolioDistributionChart(scope, myShares){
       scope.portfolioDistributionLabels =["N/A"];;
       scope.portfolioDistributionData = [1]; 
       scope.portfolioDistributionChartOptions = {
         datasetFill:false, 
         animation:false,
         showScale:true
       };

}

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

function setState(scope){
  scope.userId = window.localStorage['userId'];
  scope.isLoggedIn = isLoggedIn();
}

function addGoogleLoginToScope(scope, userProfile, myShares){
  scope.googleLogin = function() {
    userProfile.googleLogin()
    .then(function(user){
      console.log('cstep 4');
      console.log("user added: " + user.id);
      window.localStorage['userId'] = user.id;
      scope.userId = window.localStorage['userId'];
      setState(scope);
      refreshDashboard(scope, myShares);
    },function(error){
      alert("We're sorry but we could not log you in. Please try again or contact support" + error);
    });
  };
}

function refreshDashboard(scope, myShares){
  if (isLoggedIn()){
    console.log('refreshing');
    getMySharesDitributionReport(scope, myShares);
    scope.getReport();
  }
}

function setOnEnter(scope, state, myShares){
  state.get('tab.dashboard').onEnter = function() {
    refreshDashboard(scope, myShares);
  };
}

function setMySharesSummaryReport(scope, myStocksSummaryDataService){
  scope.getReport = function(){
    var date = new Date();
    myStocksSummaryDataService.getReport(date)
    .success(function(data){
      scope.MyStocksSummary = data.Rows[0];
    })
    .error(function(error){
      alert('Oh no, something went wrong while retrieving the summary data. Please try again or contact us for help');
    })
  };
}

function isLoggedIn(){ 
  var userId = window.localStorage['userId'];

  var isLoggedIn = (userId  != 'undefined' && userId != "" && userId != undefined);

  console.log('is logged in' + isLoggedIn + 'user id: ' + userId);

  return isLoggedIn;
}
