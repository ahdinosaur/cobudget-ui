Path = require('./Path.coffee')
Budgets = require('./Budgets.coffee')

module.exports = (path) ->
  Path: new Path(path)
  Budgets: new Budgets()
