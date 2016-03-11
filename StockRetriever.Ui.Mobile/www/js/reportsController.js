angular.module('starter.controllers')
.controller('ReportsCtrl', function($state, $scope, Reports, $ionicLoading,sharedServices) {

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

  sharedServices.latestDate.then(function(date){
    $scope.selectedDate = new Date(date);
  });

  $scope.orderItem = 'FiftyTwoWkGrowth';
  $scope.selectedDate = getLatestMarketOpenDate();
  $scope.openReuters = openReuters;

  var getReport = function(selectedDate, reportName){
    $ionicLoading.show({template: "loading..."});
    Reports.getReport(selectedDate, reportName)
    .success(function(data){
      $scope.rows = data.Rows;
      $ionicLoading.hide();
    })
    .error(function(error){
      alert('Ugh, something went wrong. Please try again or contact us for support');
      $ionicLoading.hide();
    });
  };

  $scope.refresh = function(selectedDate, reportName){ 
    getReport(selectedDate, reportName); 
  };

});

