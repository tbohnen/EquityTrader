var emptyShareTransaction = {TransactionType : "Buy"};

angular.module('portfolioBooster.controllers')
    .controller('mySharesController', function($scope, myShares, shareTransactions, $http, sharedServices) {

        $scope.newShareTransaction = emptyShareTransaction;
        $scope.orderItem = 'DailyMovement';
        $scope.openReuters = openReuters;

        $scope.orderItem = 'DailyMovement';
        $scope.orderItemReverse = false;

        sharedServices.latestDate.then(function(date){
            $scope.selectedDate = new Date(date);
            getReport($scope.selectedDate);
        });

        $scope.openReuters = openReuters;

        $scope.deleteTransaction = function(myEquitiesId){
            shareTransactions.deleteShareTransaction(myEquitiesId)
                .success(function(res){
                    getReport(getLatestMarketOpenDate());
                })
                .error(function(error){
                });
        };

        $scope.setOrderItem = function(field){
            if ($scope.orderItem == field){
                $scope.orderItemReverse = !$scope.orderItemReverse;
            }

            $scope.orderItem = field;
        };

        var getReport = function(selectedDate){
            myShares.getReport(selectedDate).success(function(data){
                $scope.rows = data.Rows;
                $scope.portfolioTotal = getPortfolioTotal(data.Rows);
            })
                .error(function(error){
                    alert('Ugh, something went wrong. Please try again or contact us for support');
                });
        };

        $scope.refresh = function(selectedDate){ getReport(selectedDate); };

        //move this out into it's own controller...
        $scope.saveTransaction = function(shareTransaction) {

            if (shareTransaction.TransactionType == "Sell"){
                shareTransaction.NoOfShares = -shareTransaction.NoOfShares;
            }

            shareTransactions.addShareTransaction(shareTransaction).success(function(){

                $scope.newShareTransaction = {TransactionType : "Buy"};

                alert('Share Transaction Added');

                $('#addShareTransactionModal').modal('hide');

                getReport($scope.selectedDate);
            }).error(function(e){
                alert('Ugh, something went wrong. Please try again or contact us for support');
            });
        };

    });

function getPortfolioTotal(rows){
    return _.reduce(rows, function(memo, row){ return memo + row.CurrentValue; }, 0);
}

