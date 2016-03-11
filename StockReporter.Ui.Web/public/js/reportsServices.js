angular.module('portfolioBooster.services')
.factory('reports', function($http) {
  var getReport = 
    function(selectedDate, reportName) {
    var date = selectedDate.getDate() + "-" + getMonthFromDate(selectedDate) + "-" + selectedDate.getFullYear();
    return $http.get(serverUrl + "/report/" + reportName + "?date=" + date, { timeout: 120000});
  };

  return { getReport : getReport };
});
