angular.module('starter.services', ['ngCordova'])

.factory('UserProfile', function($http, $cordovaOauth, $q){


  var googleLogin = function() {

    var deferred = $q.defer();
    console.log('cstep 1');
    $cordovaOauth.google(clientId , ["https://www.googleapis.com/auth/urlshortener", 
                         "https://www.googleapis.com/auth/userinfo.email"])
                         .then(function(result) {
                           console.log('cstep 2');
                           getGoogleProfile(result.access_token)
                           .success(function(data){
                             console.log('cstep 3');
                             saveNewUser(data)
                             .success(function(user)
                             {
                               console.log('cstep 3.1');
                               deferred.resolve(user);
                             })
                             .error(function(error){
                               console.log('cstep 3 error ' + error);
                               deferred.reject('error authenticating' + error);
                             });
                           });
                         }, function(error) {
                           console.log("error authenticating: " + error);
                           deferred.reject('error authenticating' + error);
                         });

                         return deferred.promise;
  };

  var getGoogleProfile = function(accessToken){

    var url = "https://www.googleapis.com/plus/v1/people/me?key=AIzaSyCOrpV4VVQg5ANHsO8mgb_eUaZ8PzCmM4E";

    request = { method: 'GET',
      url: url,
      headers: {
        'Authorization': 'Bearer ' + accessToken
      }
    };

    return $http(request);
  };

  var saveNewUser = function(user){
    var url = serverUrl + "/addUser/" + user.emails[0].value;

    return $http.post(url, user);
  };

  return {
    getGoogleProfile : function(accessToken){return getGoogleProfile(accessToken);},
    saveNewUser: function(user){return saveNewUser(user);},
    googleLogin: googleLogin
  };
})
.factory('ChartData',function($http){
  var getChartData = function(shareIndex, startDate, endDate,report)
  {
    //TODO: Do some refactoring here, this is horrible
    var url = serverUrl+ "/chartReport";
    url = url + "?reportname=" + report;

    if (shareIndex != undefined && shareIndex.trimLeft().length > 0){
      url = url + '&shareindex=' + shareIndex.toUpperCase();
    }

    url = url + '&startdate=' + getDateFormattedForUrl(startDate) + '&enddate=' + getDateFormattedForUrl(endDate);

    url = url + "&userId=" + window.localStorage['userId'];

    console.log(url);

    return $http.get(url,{timeout:60000});
  };

  return { chartData : function(shareIndex, startDate, endDate,report){return getChartData(shareIndex, startDate, endDate,report);}};
})
.factory('Devices',function($http){
  var addDevice = function(deviceId)
  {
    return $http.get(serverUrl + "/addDevice/" + deviceId);
  };

  return { addDevice : function(deviceId){return addDevice(deviceId);}};
})
.factory('RefreshData', function($http){

  var refresh = function(){
    return $http.get(serverUrl + "/refresh");
  };

  return { refresh : refresh };

})
.factory('MyStocksSummaryData', function($http) {

  var my_stocks_summary_data = 
    function(selectedDate) {
    var date = getDateFormattedForUrl(selectedDate);
    return $http.get(serverUrl + "/dashboard?userId=" + window.localStorage['userId']);
  };

  return { getReport : function(selectedDate) { return my_stocks_summary_data(selectedDate); } };
})

.factory('Reports', function($http) {

  var getReport = 
    function(selectedDate, reportName) {
    var date = selectedDate.getDate() + "-" + getMonthFromDate(selectedDate) + "-" + selectedDate.getFullYear();
    return $http.get(serverUrl + "/report/" + reportName + "?date=" + date + "&q=" + new Date().toString());
  };

  return { getReport : getReport };
});


