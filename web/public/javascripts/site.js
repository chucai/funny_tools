var app = angular.module('site', []);

app.controller("SiteController", function($scope, $http){
  $scope.current_page = 1;
  var request = $http({
    method: "GET",
    url: '/page/' + $scope.current_page
  });
  request.success(function(data, status){
    $scope.sites = data;
  });

  $scope.prev = function(){
    $scope.current_page = parseInt($scope.current_page) - 1;
    if($scope.current_page < 1) $scope.current_page = 1;
    reloadSites();
  };

  $scope.next = function(){
    $scope.current_page = parseInt($scope.current_page) + 1;
    if($scope.current_page > 671) $scope.current_page = 671;
    reloadSites();
  };

  $scope.goTo = function(){
    reloadSites();
  };

  $scope.search = function(){
    console.log("search ...");
    var request = $http({
      method: 'GET',
      url: "/search/" + $scope.q
    })
    request.success(function(data, status){
      $scope.sites = data;
    });
  };

  var reloadSites = function(){
    var request = $http({method: "GET", url: '/page/' + $scope.current_page });
    request.success(function(data, status){
      $scope.sites = data;
    });
  };
});
