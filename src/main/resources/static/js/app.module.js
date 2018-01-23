var dungeonMastersTools = angular.module('dungeonMastersTools', [
	'randomTownGenerator.module',
	'mainNavigation.module',
	'ui.router'
]);

dungeonMastersTools.config([
	'$stateProvider', 
	'$urlRouterProvider', 
	
	function($stateProvider, $urlRouterProvider) {
	    $urlRouterProvider.otherwise('/');
	
		var home = {
			name: 'home',
			url: '/',
			template: '<div class="jumbotron">' + 
					  	  '<h1 class="display-3">Home Page</h1>' +
						  '<hr class="my-4">' +
						  '<p>A collection of tools for Dungeon Masters</p>' +
						  '<p class="lead">' +
						  '</p>' +
				  	  '</div>'
		}
	
		var randomTownGenerator = {
		    name: 'randomTownGenerator',
		    url: '/random-town',
		    component: 'randomTownGenerator'
		}
		
		$stateProvider.state(home);
		$stateProvider.state(randomTownGenerator);
	
	}
]);	

dungeonMastersTools.controller('MainCtrl', [
	
	'$scope', 
	'$http',
	
	function MainCtrl($scope, $http){
    
		window.MY_SCOPE = $scope;
		
	}
	
]);
