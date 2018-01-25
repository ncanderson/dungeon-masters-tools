angular.
	module('monsterBuilder.service', []).
	factory('monsterBuilderFactory', function ($http) {
		
		var service = {};
		
		service.getAllSizes = function() {
			
			var response = 
				$http({
					method: 'GET',
					url: '/get-all-sizes'
				}).
				then(function success(response) {
					return response.data;
			    });
				   
			return response;
		}
		
		return service;
		
	});
