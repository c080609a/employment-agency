(function() {
    angular.module('agencyApp.vacancies', [])
        .factory('Vacancy', function($resource) {
            return $resource('/vacancies/:id', {}, {
                view: {
                    method: 'GET'
                },
                update: {
                    method: 'PUT',
                    params: {id: '@id'}
                }
            });
        })
        .controller('VacanciesCtrl', function ($scope, Vacancy) {
            $scope.vacancies = Vacancy.query();
        });
})();