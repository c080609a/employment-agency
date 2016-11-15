(function() {
    var agencyApp = angular.module('agencyApp', [
        'ngMaterial',
        'ngResource',
        'ui.router',
        'agencyApp.employees',
        'agencyApp.vacancies',
        'md.data.table',
        'agencyApp.skills'
    ]).controller('TabController', function TabController($scope, $location, $log) {
        $scope.selectedIndex = 0;

        $scope.$watch('selectedIndex', function(current, old) {
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
    });

    agencyApp.config(function ($stateProvider, $urlRouterProvider) {

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
            .state('viewEmployee', {
                url: '/employees/:id/view',
                templateUrl: 'templates/view-employee.html',
                controller: 'EmployeesCtrl'
            })
            .state('createEmployee', {
                url: '/employees/create',
                templateUrl: 'templates/edit-employee.html',
                controller: 'EmployeesCtrl'
            })
            .state('editEmployee', {
                url: '/employees/:id/edit',
                templateUrl: 'templates/edit-employee.html',
                controller: 'EmployeesCtrl'
            })
            .state('vacancies', {
                url: '/vacancies',
                templateUrl: 'templates/list-vacancies.html',
                controller: 'VacanciesCtrl'
            })
            .state('viewVacancy', {
                url: '/vacancies/:id/view',
                templateUrl: 'templates/view-vacancy.html',
                controller: 'VacanciesCtrl'
            })
            .state('createVacancy', {
                url: '/vacancies/create',
                templateUrl: 'templates/edit-vacancy.html',
                controller: 'VacanciesCtrl'
            })
            .state('editVacancy', {
                url: '/vacancies/:id/edit',
                templateUrl: 'templates/edit-vacancy.html',
                controller: 'VacanciesCtrl'
            });

        // redirect unmatched URL to home
        $urlRouterProvider.otherwise("/home");
    });

})();