// Ionic Starter App

// angular.module is a global place for creating, registering and retrieving Angular modules
// 'starter' is the name of this angular module example (also set in a <body> attribute in index.html)
// the 2nd parameter is an array of 'requires'
// 'starter.services' is found in services.js
// 'starter.controllers' is found in controllers.js
angular.module('starter', ['ionic', 'starter.controllers', 'starter.services','pushnotification','ngCordova','chart.js'])

.run(function($ionicPlatform, PushProcessingService) {
  $ionicPlatform.ready(function() {
    // Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
    // for form inputs)
    if (window.cordova && window.cordova.plugins.Keyboard) {
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
    }
    if (window.StatusBar) {
      // org.apache.cordova.statusbar required
      StatusBar.styleDefault();
    }
    PushProcessingService.initialize();

    Chart.defaults.global.animation = false;

  });
})
.config(function($stateProvider, $urlRouterProvider, $httpProvider) {
  
  //Enable cross domain calls
  $httpProvider.defaults.useXDomain = true;

  //Remove the header used to identify ajax call  that would prevent CORS from working
  delete $httpProvider.defaults.headers.common['X-Requested-With'];

  // Ionic uses AngularUI Router which uses the concept of states
  // Learn more here: https://github.com/angular-ui/ui-router
  // Set up the various states which the app can be in.
  // Each state's controller can be found in controllers.js
  $stateProvider

  // setup an abstract state for the tabs directive
    .state('tab', {
    url: "/tab",
    abstract: true,
    templateUrl: "templates/tabs.html"
  })

  // Each tab has its own nav history stack:

  .state('tab.my-watchlist', {
      url: '/myWatchlist',
      views: {
        'tab-my-watchlist': {
          templateUrl: 'templates/tab-my-watchlist.html',
          controller: 'MyWatchlistCtrl'
        }
      }
    })
  .state('tab.my-shares', {
      url: '/myShares',
      views: {
        'tab-my-shares': {
          templateUrl: 'templates/tab-my-shares.html',
          controller: 'MySharesCtrl'
        }
      }
    })
  .state('tab.reports', {
      url: '/reports',
      views: {
        'tab-reports': {
          templateUrl: 'templates/tab-reports.html',
          controller: 'ReportsCtrl'
        }
      }
    })
  .state('tab.dashboard', {
      url: '/dashboard',
      views: {
        'tab-dashboard': {
          templateUrl: 'templates/tab-dashboard.html',
          controller: 'DashboardCtrl'
        }
      }
  })
  .state('tab.charts', {
      url: '/charts',
      views: {
        'tab-charts': {
          templateUrl: 'templates/tab-charts.html',
          controller: 'ChartsCtrl'
        }
      }
  })
  .state('tab.strategies', {
      url: '/strategies',
      views: {
        'tab-strategies': {
          templateUrl: 'templates/tab-strategies.html',
          controller: 'StrategiesCtrl'
        }
      }
  });
  // if none of the above states are matched, use this as the fallback
  $urlRouterProvider.otherwise('/tab/dashboard');

});
