angular.
	module('randomTown.controller', []).
	
	component('randomTownGenerator', {
			
		templateUrl: 'js/components/randomTownGenerator/randomTownGenerator.tpl.html'
		
	}).	
	
	controller('RandomTownCtrl', 
	
		function($scope, randomTownFactory) {
		
			$scope.getAllRegions = function () {
				
				var promise = randomTownFactory.getAllRegions();
				
				promise.then(function(data) {
					$scope.regions = data;
				}).catch(function(errorResponse) {
					console.log("ERROR", errorResponse.status)
				}); 
			}
			
			$scope.getRandomTown = function () {

				if (typeof $scope.guidEntity === 'undefined' || typeof $scope.townSize === 'undefined') { return };

				var regionGuid = 'region-guid=' + $scope.guidEntity; 
				var townSize = 'town-size=' + $scope.townSize;
												
				var promise = randomTownFactory.getRandomTown(regionGuid, townSize);
				
				promise.then(function(data) {
					$scope.randomTown = data;
				}).catch(function(errorResponse) {
					console.log("ERROR", errorResponse.status)
				});
				
			}
		}
	);		
	