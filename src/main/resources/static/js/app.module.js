var app = angular.module('dungeonMastersTools', [
	
]);

app.controller('RandomTownCtrl', [
	
	'$scope', 
	'$http',
	
	function($scope, $http){
        
		$scope.getAllRegions = function() {
			
			//var url = $location.absUrl() + "all-regions";
			
			$http({
				  method: 'GET',
				  url: '/all-regions'
			}).then(function successCallback(response) {
				
				$scope.regions = response.data;
	
				console.log($scope.regions);
				
			}, function errorCallback(response) {

				console.log('error');
				
			});
		};
		
		$scope.getRandomTown = function() {
				
			var guidEntity = $scope.guidEntity; 
			
			$http({
				  method: 'GET',
				  url: '/region-name?region-guid=' + guidEntity				 
			}).then(function successCallback(response) {
				
				console.log(response.data);
	
				//console.log($scope.regions);
				
			}, function errorCallback(response) {

				console.log('error');
				
			});

		};
    }
]);