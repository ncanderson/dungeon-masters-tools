var app = angular.module('dungeonMastersTools', [
	'randomTownGenerator'
]);

app.controller('RandomTownCtrl', [
	
	'$scope', 
	'$http',
	
	function($scope, $http){
    
		window.MY_SCOPE = $scope;
		
		$scope.getAllRegions = function() {
			
			$http({
				  method: 'GET',
				  url: '/all-regions'
			}).then(function successCallback(response) {
				
				$scope.regions = response.data;
	
			}, function errorCallback(response) {

				console.log('error');
				
			});
		};
		
		$scope.getRandomTown = function() {
				
			var regionGuid = 'region-guid=' + $scope.guidEntity; 
			var townSize = 'town-size=' + $scope.townSize;
			
			if (typeof regionGuid === 'undefined') { return };
			
			$http({
				  method: 'GET',
				  url: '/region-name?' + regionGuid + '&' + townSize
			}).then(function successCallback(response) {
				
				$scope.randomTown = response.data; 

				console.log($scope.randomTown);
					
			}, function errorCallback(response) {

				console.log('$http error');
				
			});
			
		};
    }
]);