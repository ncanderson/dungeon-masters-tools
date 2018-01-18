angular.
	module('randomTown.service', []).
	factory('randomTownFactory', function ($http) {
		
		var service = {};
		
		service.getAllRegions = function() {
			
			var response = 
				$http({
					method: 'GET',
					url: '/all-regions'
				}).
				then(function success(response) {
					return response.data;
			    });
				   
			return response;
		}
		
		service.getRandomTown = function(regionGuid, townSize) {
			
			var response = 
				$http({
					method: 'GET',
					url: '/region-name?' + regionGuid + '&' + townSize
				}).
				then(function success(response) {
					return response.data;
			    });
				   
			return response;
		}
	
		return service;
	});
