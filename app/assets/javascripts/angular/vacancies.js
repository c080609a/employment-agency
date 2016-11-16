(function() {
    angular.module('agencyApp.vacancies', [])
        .factory('Vacancy', function($resource) {
            return $resource('/vacancies/:id', {}, {
                show: {
                    method: 'GET'
                },
                update: {
                    method: 'PUT',
                    params: {id: '@id'}
                },
                findEmployees: {
                    method: 'GET'
                },
                delete: {
                    method: 'DELETE',
                    params: {id: '@id'}
                }
            });
        })
        .controller('VacanciesCtrl', function ($scope, $state, $stateParams, $mdDialog, Vacancy) {

            var originatorEv;

            $scope.vacancies = {};

            $scope.query = {
                order: 'title',
                dir: 'asc',
                page: 1
            }

            $scope.openMenu = function($mdOpenMenu, ev) {
                originatorEv = ev;
                $mdOpenMenu(ev);
            };

            $scope.setOrder = function () {
                $scope.promise = Vacancy.query($scope.query, success).$promise;
            };


            function success(items) {
                $scope.vacancies = items;
            }

            $scope.retrieveList = function() {
                $scope.promise = Vacancy.query($scope.query, success).$promise;
            }
            // Deletion confirm dialog
            $scope.confirmDeletion = function(ev, data) {
                var vacancyId = data;
                var confirm = $mdDialog.confirm()
                    .title('Удалить запись?')
                    .textContent('Действие невозможно будет отменить.')
                    .ariaLabel('Delete vacancy')
                    .targetEvent(ev)
                    .ok('ОК')
                    .cancel('Отмена');

                $mdDialog.show(confirm).then(function() {
                    $scope.promise = Vacancy.delete({id: vacancyId}).$promise;
                    $scope.promise.then(function(response) {
                        if (response.success) {
                            $scope.retrieveList();
                        }
                    });
                });
            };

            $scope.retrieveList();
        })
        .controller('SingleVacancyCtrl', function ($scope, $state, $stateParams, Vacancy) {
            var id = $stateParams.id || null;
            $scope.state = $state.current;
            $scope.params = $stateParams;
            $scope.vacancy = {};
            $scope.skills = {};
            $scope.pageTitle = 'Редактировать вакансию';

            if (id) {
                Vacancy.show({id: id}).$promise.then(function(response) {
                    $scope.vacancy = response.data;
                    $scope.skills = response.skills;
                });
            } else {
              $scope.pageTitle = 'Добавить вакансию';
            }

            // Save data
            $scope.saveItem = function(data) {
                if (data.id) {
                  Vacancy.update(data).$promise.then(function(response) {
                    if (response.success) {
                      $state.go('vacancies');
                    }
                  });
                } else {
                  Vacancy.save(data).$promise.then(function(response) {
                    if (response.success) {
                      $state.go('vacancies');
                    }
                  });
                }
            }

        });
})();
