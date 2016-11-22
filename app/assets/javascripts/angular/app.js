(function() {
    angular.module('agencyApp', [
        'ngRoute',
        'ngMaterial',
        'ngResource',
        'ngMessages',
        'ui.router',
        'agencyApp.employees',
        'agencyApp.vacancies',
        'md.data.table',
    ]).controller('TabController', TabController)
        .config(appConfig);

    TabController.$inject = ['$scope', '$location'];

    appConfig.$inject = ['$stateProvider', '$urlRouterProvider', '$mdThemingProvider'];

    function TabController($scope, $location) {
        $scope.selectedIndex = 0;

        $scope.$watch('selectedIndex', function(current) {
            switch (current) {
                case 0:
                    $location.url("/home");
                    break;
                case 1:
                    $location.url("/employees");
                    break;
                case 2:
                    $location.url("/vacancies");
                    break;
            }
        });
    }


    function appConfig ($stateProvider, $urlRouterProvider, $mdThemingProvider) {

        $mdThemingProvider
            .theme('default')
            .primaryPalette('teal')
            .accentPalette('green')
            .warnPalette('red')
            .backgroundPalette('grey');


        $stateProvider
            .state('home', {
                url: '/home',
                templateUrl: 'templates/home.html'
            })
            .state('employees', {
                url: '/employees',
                templateUrl: 'templates/list-employees.html',
                controller: 'EmployeesCtrl'
            })
            .state('createEmployee', {
                url: '/employees/add',
                templateUrl: 'templates/edit-employee.html',
                controller: 'SingleEmployeeCtrl'
            })
            .state('viewEmployee', {
                url: '/employees/{id:[0-9]+}',
                templateUrl: 'templates/view-employee.html',
                controller: 'SingleEmployeeCtrl'
            })
            .state('editEmployee', {
                url: '/employees/{id:[0-9]+}/edit',
                templateUrl: 'templates/edit-employee.html',
                controller: 'SingleEmployeeCtrl'
            })
            .state('vacancies', {
                url: '/vacancies',
                templateUrl: 'templates/list-vacancies.html',
                controller: 'VacanciesCtrl'
            })
            .state('createVacancy', {
                url: '/vacancies/add',
                templateUrl: 'templates/edit-vacancy.html',
                controller: 'SingleVacancyCtrl'
            })
            .state('viewVacancy', {
                url: '/vacancies/{id:[0-9]+}',
                templateUrl: 'templates/view-vacancy.html',
                controller: 'SingleVacancyCtrl'
            })
            .state('editVacancy', {
                url: '/vacancies/{id:[0-9]+}/edit',
                templateUrl: 'templates/edit-vacancy.html',
                controller: 'SingleVacancyCtrl'
            });

        // redirect unmatched URL to home
        $urlRouterProvider.otherwise("/home");
    }

})();
