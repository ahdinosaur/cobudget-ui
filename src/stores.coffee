Nav = require('nav/store.coffee')
Budgets = require('budgets/store.coffee')

module.exports = (path) ->
  Nav: new Nav(path)
  Budgets: new Budgets()
