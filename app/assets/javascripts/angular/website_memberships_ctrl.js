var app = angular.module('app', ['ngResource', 'ngRoute']);

app.factory('WebsiteMembership', ['$resource', function($resource) {
  return $resource('/admin/website_memberships/:id', null,
      {
          'update': { method:'PUT' }
      });
}]);

app.controller('WebsiteMembershipsCtrl',
  ['$scope', 'WebsiteMembership',
  function($scope, WebsiteMembership) {

    $scope.newWM = new WebsiteMembership();
    $scope.website_memberships = WebsiteMembership.query();

    $scope.createWebsiteMembership = function(){
      WebsiteMembership.save({ website_membership: $scope.newWM }, function(d){
        $scope.website_memberships.push(new WebsiteMembership(d));
      }, function(){
        alert('Could not add website membership');
      });
    };

    $scope.deleteWebsiteMembership = function(wm){
      WebsiteMembership.delete({ id: wm.id }, function(){
        $scope.website_memberships = WebsiteMembership.query();
      }, function(){
        alert('Could not remove this website membership');
      });
    };

    $scope.editWebsiteMembership = function(wm){
      // Todo: angularize view
      location.href = '/admin/website_memberships/' + wm.id + '/edit';
    };
}]);
