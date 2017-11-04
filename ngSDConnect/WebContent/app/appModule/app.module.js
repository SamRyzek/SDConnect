
angular.module("appModule", ['ngRoute', 'ngCookies', 'authModule'])
	.config(function($routeProvider){
	
		$routeProvider
			.when('/login',{
			template:'<login></login>'
			})
			.when('/', {
				template:'<login></login>' //these are the snake case names of the comps
			})
			.when('/home', {
				template:'<home></home>' //these are the snake case names of the comps
			})
			.when('/alumni', {
				template:'<alumni></alumni>' //these are the snake case names of the comps
			})
			.when('/resources',{
				template:'<resource></resource>'
			})
			.when('/users/:id/profiles',{
				template:'<profile></profile>'
			})
			.when('/profile',{
				template:'<alumni></alumni>'
			})
			.when('/users/:id/registerprofiles',{
				template:'<registerprofile></registerprofile>'
			})
			.otherwise({
				template:'<h1>404 - NOT FOUND </h1>'
			})	
		
	})
