angular.module('portfolioBooster.services')
.factory('myShares', function($http) {
  var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

  var my_shares =
    function(selectedDate) {
    var date = selectedDate.getDate() + "-" + getMonthFromDate(selectedDate) + "-" + selectedDate.getFullYear();
    return $http.get(serverUrl + "/report/MyStocksReport?date=" + date+ "&userId=" + window.localStorage['userId'] + '&cached=false');
  };

  return { getReport : function(selectedDate) { return my_shares(selectedDate); } };
})
.factory('shareTransactions', function($http) {

  var addShareTransaction = function(shareTransaction){
    var url = serverUrl + '/addMySharesTransaction';

    shareTransaction.UserId = window.localStorage['userId'];
    shareTransaction.ShareIndex = shareTransaction.ShareIndex.toUpperCase();

    return $http.post(url, shareTransaction);
  };

  var deleteShareTransaction = function(mySharesId){
    var url = serverUrl + '/deleteMySharesTransaction/' + mySharesId;

    return $http.post(url);
  }

  return { addShareTransaction : function(shareTransaction){ return addShareTransaction(shareTransaction); },
           deleteShareTransaction : deleteShareTransaction };
});
