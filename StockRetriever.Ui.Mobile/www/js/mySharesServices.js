angular.module('starter.services')
.factory('MyShares', function($http) {
  var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

  var my_shares = 
    function(selectedDate) {
    var date = selectedDate.getDate() + "-" + getMonthFromDate(selectedDate) + "-" + selectedDate.getFullYear();
    return $http.get(serverUrl + "/report/MyStocksReport?date=" + date+ "&userId=" + window.localStorage['userId'] + "&cached=false");
  };

  return { getReport : function(selectedDate) { return my_shares(selectedDate); } };
})
.factory('ShareTransactions', function($http) {

  var addShareTransaction = function(shareTransaction){
    var url = serverUrl + '/addMySharesTransaction';

    shareTransaction.UserId = window.localStorage['userId'];
    shareTransaction.ShareIndex = shareTransaction.ShareIndex.toUpperCase();

    return $http.post(url, shareTransaction);
  };

  return { addShareTransaction : function(shareTransaction){ return addShareTransaction(shareTransaction); } };
});
