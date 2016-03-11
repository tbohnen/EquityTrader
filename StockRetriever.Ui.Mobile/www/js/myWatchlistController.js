angular.module('starter.controllers')
.controller('MyWatchlistCtrl', function($state, $scope, MyWatchlist, $ionicLoading, $ionicModal, WatchlistTransactions, sharedServices) {

  $scope.newWatchlistShare = { DateAdded : new Date()};

  
  $scope.orderItem = 'DailyMovement';
  $scope.openReuters = openReuters;

  $state.get('tab.my-watchlist').onEnter = function() { 
    sharedServices.latestDate.then(function(date){
      $scope.selectedDate = new Date(date);
      getReport($scope.selectedDate);
    });
  };

  sharedServices.latestDate.then(function(date){
    $scope.selectedDate = new Date(date);
    getReport($scope.selectedDate);
  });

  var getReport = function(selectedDate){
    $ionicLoading.show({template: "loading..."});
    MyWatchlist.getReport(selectedDate).success(function(data){
      $ionicLoading.hide();
      $scope.rows = data.Rows;
      $scope.portfolioTotal = getPortfolioTotal(data.Rows);
    })
    .error(function(error){
      alert('Ugh, something went wrong. Please try again or contact us for support');
      $ionicLoading.hide();
    });
  };

  $scope.refresh = function(selectedDate){ getReport(selectedDate); };

  //move this out into it's own controller...
  $scope.saveTransaction = function(shareTransaction) {

    WatchlistTransactions.addShareTransaction(shareTransaction).success(function(){

      alert('Watchlist item added');

      $scope.addShareTransactionModal.hide();
      getReport($scope.selectedDate);
    }).error(function(e){
      alert('Ugh, something went wrong. Please try again or contact us for support');
    });
  };

  $ionicModal.fromTemplateUrl('templates/add-watchlist-share.html', {
    scope: $scope,
    animation: 'slide-in-up'
  }).then(function(modal) {
    $scope.addShareTransactionModal = modal;
  });

  $scope.addWatchlistShare = function() {
    $scope.addShareTransactionModal.show();
  };

  $scope.closeModal = function() {
    $scope.addShareTransactionModal.hide();
  };
});

function getPortfolioTotal(rows){
  return _.reduce(rows, function(memo, row){ return memo + row.CurrentValue; }, 0);
}
