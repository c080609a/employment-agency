(function() {
    angular.module('agencyApp.vacancies', ['ui.utils.masks'])
        .factory('Vacancy', Vacancy)
        .controller('VacanciesCtrl', VacanciesCtrl)
        .controller('SingleVacancyCtrl', SingleVacancyCtrl);

    Vacancy.$inject = ['$resource'];
    VacanciesCtrl.$inject = ['$scope', '$mdDialog', '$mdConstant','Vacancy'];
    SingleVacancyCtrl.$inject = ['$scope', '$state', '$stateParams', '$http', 'Vacancy'];


    function Vacancy ($resource) {
        return $resource('/vacancies/:id', {}, {
            query: {
                method: 'GET'
            },
            show: {
                method: 'GET'
            },
            update: {
                method: 'PUT',
                params: {id: '@id'}
            },
            matchEmployees: {
                url: '/vacancies/:id/get_matches',
                method: 'GET'
            },
            delete: {
                method: 'DELETE',
                params: {id: '@id'}
            }
        });
    }

    function VacanciesCtrl ($scope, $mdDialog, $mdConstant, Vacancy) {

        var originatorEv;

        $scope.vacancies = {};

        // query params
        $scope.query = {
            order: 'title',
            dir: 'asc',
            page: 1,
            limit: 10
        }

        // total entries returned
        $scope.total = 0;

        $scope.paginationLabels = {
            of: 'из',
            page: 'Страница:',
            rowsPerPage: 'Показывать:'
        }

        $scope.separatorKeys = [$mdConstant.KEY_CODE.ENTER, $mdConstant.KEY_CODE.COMMA];

        $scope.openMenu = function($mdOpenMenu, ev) {
            originatorEv = ev;
            $mdOpenMenu(ev);
        };

        $scope.setQuery = function () {
            $scope.promise = Vacancy.query($scope.query, success).$promise;
        };


        function success(result) {
            $scope.vacancies = result.rows;
            $scope.total = result.total;
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
    }

    function SingleVacancyCtrl ($scope, $state, $stateParams, $http, Vacancy) {
        var id = $stateParams.id || null;
        $scope.state = $state.current;
        $scope.params = $stateParams;
        $scope.foundSkills = [];
        $scope.vacancy = {
            skills: []
        };
        $scope.selectedSkills = [];
        $scope.searchText = null;
        $scope.pageTitle = 'Редактировать вакансию';
        $scope.matchesFound = false;
        $scope.matches = {
            partial: [],
            full: []
        }

        // validation errors
        $scope.errors = {};

        if (id) {
            Vacancy.show({id: id}).$promise.then(function(response) {
                $scope.vacancy = response.data;
                $scope.vacancy.skills = response.skills;
                $scope.selectedSkills = response.data.skills;
            });
        } else {
            $scope.pageTitle = 'Добавить вакансию';
        }

        /**
         * Save data
         */
        $scope.saveItem = function(data) {
            if (data.id) {
                Vacancy.update(data).$promise.then(function(response) {
                    if (response.success) {
                        $state.go('vacancies');
                    } else if (response.errors) {
                        $scope.errors = response.errors;
                    }
                });
            } else {
                Vacancy.save(data).$promise.then(function(response) {
                    if (response.success) {
                        $state.go('vacancies');
                    } else if (response.errors) {
                        $scope.errors = response.errors;
                    }
                });
            }
        }

        /**
         * Search for skills
         */
        $scope.querySearch = function (query) {
            $http({
                url: '/skills',
                params: {query: query},
                method: 'GET'
            }).then(function(response) {
                $scope.foundSkills = response.data;
                return response.data;
            });
        }

        /**
         * Search for matching employees
         * @param {integer} id
         */
        $scope.matchEmployees = function(id) {
            Vacancy.matchEmployees({id: id}).$promise.then(function(response) {
                $scope.matchesFound = true;
                $scope.matches.full = response.full;
                $scope.matches.partial = response.partial;
            });
        }

        /**
         * Go back button action
         */
        $scope.goBack = function() {
            window.history.back();
        }


        $scope.transformChip = function(chip) {
            if (angular.isObject(chip)) {
                return chip;
            }
        }

    }
})();
