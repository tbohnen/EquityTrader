angular.module('starter.services')
.factory('Strategies', function($http){
  var getIndustryBestStrategy = function(minimumMarketCap, numberOfBiggestIndustries, numberOfTopPerformers){
    
    var url = serverUrl + "/strategy/industryBest?mimimumMarketCap=" + minimumMarketCap + 
      "&numberOfBiggestIndustries=" + numberOfBiggestIndustries + 
      "&numberOfTopPerformers=" + numberOfTopPerformers
    return $http.get(url);
  };

  return { getIndustryBest: getIndustryBestStrategy };

});
