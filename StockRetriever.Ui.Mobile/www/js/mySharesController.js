var emptyShareTransaction = {TransactionType : "Buy"};

angular.module('starter.controllers')
.controller('MySharesCtrl', function($state, $scope, MyShares, $ionicLoading, $ionicModal, ShareTransactions, sharedServices) {

  $scope.newShareTransaction = emptyShareTransaction;
  $scope.orderItem = 'DailyMovement';
  $scope.openReuters = openReuters;

  $state.get('tab.my-shares').onEnter = function() { 
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
    MyShares.getReport(selectedDate).success(function(data){
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

    if (shareTransaction.TransactionType == "Sell"){
      shareTransaction.NoOfShares = -shareTransaction.NoOfShares;
    }

    ShareTransactions.addShareTransaction(shareTransaction).success(function(){

      $scope.newShareTransaction = {TransactionType : "Buy"};

      alert('Share Transaction Added');

      $scope.addShareTransactionModal.hide();
      getReport($scope.selectedDate);
    }).error(function(e){
      alert('Ugh, something went wrong. Please try again or contact us for support');
    });
  };

  $scope.changeTransactionType = function(a){
    if ($scope.newShareTransaction.TransactionType == "Sell"){
      $scope.newShareTransaction.TransactionType = "Buy";
    }
    else{
      $scope.newShareTransaction.TransactionType = "Sell";
    }
    console.log($scope.newShareTransaction.TransactionType);

  };

  $ionicModal.fromTemplateUrl('templates/add-share-transaction.html', {
    scope: $scope,
    animation: 'slide-in-up'
  }).then(function(modal) {
    $scope.addShareTransactionModal = modal;
  });

  $scope.addShareTransaction = function() {
    $scope.addShareTransactionModal.show();
  };

  $scope.closeModal = function() {
    $scope.addShareTransactionModal.hide();
  };
});

function getPortfolioTotal(rows){
  return _.reduce(rows, function(memo, row){ return memo + row.CurrentValue; }, 0);
}
