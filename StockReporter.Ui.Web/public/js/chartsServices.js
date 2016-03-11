angular.module('portfolioBooster.services')
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
    });
