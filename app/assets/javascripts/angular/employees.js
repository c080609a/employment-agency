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
            var originatorEv;

            $scope.query = {
                order: 'name',
                dir: 'asc',
                page: 1
            }

            $scope.openMenu = function($mdOpenMenu, ev) {
                originatorEv = ev;
                $mdOpenMenu(ev);
            };

            $scope.setOrder = function () {
                $scope.promise = Employee.query($scope.query, success).$promise;
            };

            function success(items) {
                $scope.employees = items;
            }

            $scope.employees = Employee.query($scope.query);
        })
        .filter('activeOrNot', function() {
            return function(input) {
                return input ? 'Активен' : 'Неактивен'
            }
        });
})();