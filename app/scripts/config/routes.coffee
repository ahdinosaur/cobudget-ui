module.exports = ($routeProvider) ->
  $routeProvider
    .when '/',
      templateUrl: '/views/budget-overview.html'
      controller: require('../controllers/budget_controller.coffee')
