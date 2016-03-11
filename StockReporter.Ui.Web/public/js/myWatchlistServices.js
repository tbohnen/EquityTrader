angular.module('portfolioBooster.services')
.factory('myWatchlist', function($http) {
  var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

  var my_watchlist = 
    function(selectedDate) {
    var date = selectedDate.getDate() + "-" + getMonthFromDate(selectedDate) + "-" + selectedDate.getFullYear();
    return $http.get(serverUrl + "/report/MyWatchlistReport?date=" + date+ "&userId=" + window.localStorage['userId'] + '&cached=false');
  };

  return { getReport : function(selectedDate) { return my_watchlist(selectedDate); } };
})
.factory('watchlist', function($http) {

  var addWatchlistShare = function(watchlistShare){
    var url = serverUrl + '/addWatchlistShare';

    watchlistShare.UserId = window.localStorage['userId'];
    watchlistShare.ShareIndex = watchlistShare.ShareIndex.toUpperCase();

    return $http.post(url, watchlistShare);
  };

  var deleteWatchlistShare = function(myWatchlistId){
    var url = serverUrl + '/deleteWatchlistShare/' + myWatchlistId;

    return $http.post(url);
  }

  return { addWatchlistShare : addWatchlistShare ,
           deleteWatchlistShare : deleteWatchlistShare };
});
