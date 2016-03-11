angular.module('starter.services')
.factory('sharedServices', function($http, $q) {

  var latestDatePromise = $q.defer();
  var latestDate = 

  $http.get(serverUrl + "/latestDate")
    .success(function(data){
      console.log(data);
      latestDatePromise.resolve(data.date);
    });

  return { latestDate : latestDatePromise.promise };
});

