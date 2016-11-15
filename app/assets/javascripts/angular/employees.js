(function() {
    angular.module('agencyApp.employees', [])
        .factory('Employee', function($resource) {
            return $resource('/employees/:id', {}, {
                view: {
                    method: 'GET'
                },
                update: {
                    method: 'PUT',
                    params: {id: '@id'}
                }
            });
        })
        .controller('EmployeesCtrl', function ($scope, Employee) {
            $scope.employees = Employee.query();
        });
})();