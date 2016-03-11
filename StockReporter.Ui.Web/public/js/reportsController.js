angular.module('portfolioBooster.controllers')
.controller('reportsController', function($scope, reports) {

  $scope.orderItem = 'FiftyTwoWkGrowth';
  $scope.orderItemReverse = false;

  $scope.selectedDate = getLatestMarketOpenDate();
  $scope.openReuters = openReuters;

  $scope.setOrderItem = function(field){

    if ($scope.orderItem == field){
      $scope.orderItemReverse = !$scope.orderItemReverse;
    }

    $scope.orderItem = field;
  };

  var getReport = function(selectedDate, reportName){
      if (reportName == undefined){
          alert('Please select a report name first.');
          return;
      }

    console.log('starting...');
    reports.getReport(selectedDate, reportName)
    .success(function(data){
      console.log('starting...');
      $scope.rows = data.Rows;
    })
    .error(function(error){
      alert('Ugh, something went wrong. Please try again or contact us for support');
    });
  };

  $scope.refresh = function(selectedDate, reportName){ 
    getReport(selectedDate, reportName); 
  };

    $scope.stockMatch = function( criteria ) {
        return function( item ) {
            if (criteria == undefined) return true;
            criteria = criteria.toLowerCase();

            if (item == null) return false;

            var matched = item.ShareIndex.toLowerCase().indexOf(criteria) !== -1 ||
                    (item.ShareName != null && item.ShareName.toLowerCase().indexOf(criteria) !== -1) ||
                    (item.Sector != null && item.Sector.toLowerCase().indexOf(criteria) !== -1);

            return matched;
        };
    };

  $scope.selectShare = function(share){
    if ($scope.selectedShare == share.ShareIndex){
      $scope.selectedShare = "";
    }
    else{
      $scope.selectedShare = share.ShareIndex;
    }
  };

});

