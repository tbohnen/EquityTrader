angular.module('portfolioBooster.services', [])
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
    return $http.get(serverUrl + "/report/" + reportName + "?date=" + date);
  };

  return { getReport : getReport };
});


