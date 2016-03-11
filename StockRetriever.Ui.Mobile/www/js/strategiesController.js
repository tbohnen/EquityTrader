angular.module('starter.controllers')
.controller('StrategiesCtrl', function($scope, $ionicLoading, Strategies) {
  $scope.runStrategy = function(strategy, mimimumMarketCap, numberOfBiggestIndustries, numberOfTopPerformers){
    if (strategy == "IndustryBest"){
      Strategies.getIndustryBest(mimimumMarketCap, numberOfBiggestIndustries, numberOfTopPerformers)
      .success(function(data){
        $scope.strategyResult = data[0];
      })
      .error(function(e){
        alert('oops');
      });
    };
  };

});
