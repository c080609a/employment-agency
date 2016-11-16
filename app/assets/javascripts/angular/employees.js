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
                },
                delete: {
                    method: 'DELETE',
                    params: {id: '@id'}
                }
            });
        })
        .controller('EmployeesCtrl', function ($scope, $state, $stateParams, $mdDialog, Employee) {
          var originatorEv;

          $scope.employees = {};

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

          $scope.retrieveList = function() {
              $scope.promise = Employee.query($scope.query, success).$promise;
          }
          // Deletion confirm dialog
          $scope.confirmDeletion = function(ev, data) {
              var EmployeeId = data;
              var confirm = $mdDialog.confirm()
                  .title('Удалить запись?')
                  .textContent('Действие невозможно будет отменить.')
                  .ariaLabel('Delete Employee')
                  .targetEvent(ev)
                  .ok('ОК')
                  .cancel('Отмена');

              $mdDialog.show(confirm).then(function() {
                  $scope.promise = Employee.delete({id: EmployeeId}).$promise;
                  $scope.promise.then(function(response) {
                      if (response.success) {
                          $scope.retrieveList();
                      }
                  });
              });
          };

          $scope.retrieveList();
        })
        .filter('activeOrNot', function() {
            return function(input) {
                return input ? 'Активен' : 'Неактивен'
            }
        });
})();
