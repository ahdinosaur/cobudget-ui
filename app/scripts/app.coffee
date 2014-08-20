angular = require('angular')
require('angular-route')(window, angular)

angular
  .module('cobudget', ['ngRoute'])
  .config(require('./config/routes.coffee'))
