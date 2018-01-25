angular.
	module('monsterBuilder.controller', []).
	
	component('monsterBuilder', {
			
		templateUrl: 'js/components/monsterBuilder/monsterBuilder.tpl.html'
		
	}).	
	
	controller('MonsterBuilderCtrl', 
	
		function($scope, monsterBuilderFactory) {
		
			$scope.getAllSizes = function () {
				
				var promise = monsterBuilderFactory.getAllSizes();
				
				promise.then(function(data) {
					$scope.sizes = data;
					console.log(data);
				}).catch(function(errorResponse) {
					console.log("ERROR", errorResponse.status)
				}); 
			}
			
		}
	);		
	