Nav = require('nav/store.coffee')
Budgets = require('budgets/store.coffee')

routes = require('routes')

module.exports = (path) ->
  Nav: new Nav({ path, routes })
  Budgets: new Budgets()
