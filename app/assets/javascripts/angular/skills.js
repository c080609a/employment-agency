(function() {
    angular.module('agencyApp.skills', [])
        .factory('skill', function($resource) {
            return $resource('/skills/:id', {}, {
                view: {
                    method: 'GET'
                },
                update: {
                    method: 'PUT',
                    params: {id: '@id'}
                }
            });
        })
        .controller('SkillssCtrl', function ($scope) {

        });;
})();