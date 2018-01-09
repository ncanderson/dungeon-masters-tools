var app = angular.module('dungeonMastersTools', [
	'randomTownGenerator'
	//'ui.router'
]);

app.controller('MainCtrl', [
	
	'$scope', 
	'$http',
	
	function($scope, $http){
    
		$scope.templates = [
			{ name: 'navigation.tpl.html', url: 'js/components/shared/navigation/navigation.tpl.html'}
		]
		  
		$scope.template = $scope.templates[0];
    
	}
	
]);
