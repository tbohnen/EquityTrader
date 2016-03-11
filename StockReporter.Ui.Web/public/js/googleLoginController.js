angular.module('portfolioBooster.controllers')
.controller('googleLoginController', function($scope, $http){

  $scope.isLoggedIn = isLoggedIn();

  $scope.setUserId = function(userId){ 
    if (userId == 'error'){
      alert('We had a problem logging you in. please try again or contact support');
    }
    else if (!isLoggedIn() && userId != 'undefined' && userId != undefined){
      console.log('set login id' + userId);
      $scope.userId = userId;
      window.localStorage['userId'] = userId;
      $scope.isLoggedIn = isLoggedIn();
    }
  };

  $scope.loginGoogle = function(){ 
    authGoogle($http);
  }; 
});

function authGoogle($http) { 
  var url = location.protocol + '//' + location.hostname+(location.port ? ':'+location.port: '');

  var redirectUri = url + '/authorized';
  var url = 'https://accounts.google.com/o/oauth2/auth?response_type=code&client_id=' + clientId 
  + '&redirect_uri=' + redirectUri 
  + '&scope=email&access_type=online';

  window.location = url;
}

function isLoggedIn(){ 
  var userId = window.localStorage['userId'];

  var isLoggedIn = (userId  != 'undefined' && userId != "" && userId != undefined);

  console.log('is logged in' + isLoggedIn);

  return isLoggedIn;
}
