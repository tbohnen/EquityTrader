angular.module('portfolioBooster.controllers')
.controller('myWatchlistController', function($scope, myWatchlist, watchlist, $http, sharedServices) {

  $scope.orderItem = 'DailyMovement';
  $scope.orderItemReverse = false;

  sharedServices.latestDate.then(function(date){
    $scope.selectedDate = new Date(date);
    getReport($scope.selectedDate);
  });

  $scope.openReuters = openReuters;

  $scope.deleteWatchlistShare = function(myWatchlistId){
    watchlist.deleteWatchlistShare(myWatchlistId)
    .success(function(res){
      getReport($scope.selectedDate);
    })
    .error(function(error){
    
    });
  };

  $scope.setOrderItem = function(field){
    if ($scope.orderItem == field){
      $scope.orderItemReverse = !$scope.orderItemReverse;
    }

    $scope.orderItem = field;
  }

  var getReport = function(selectedDate){
    myWatchlist.getReport(selectedDate).success(function(data){
      $scope.rows = data.Rows;
    })
    .error(function(error){
      alert('Ugh, something went wrong. Please try again or contact us for support');
    });
  };

  $scope.refresh = function(selectedDate){ getReport(selectedDate); };
});

function getPortfolioTotal(rows){
 return _.reduce(rows, function(memo, row){ return memo + row.CurrentValue; }, 0);
}

