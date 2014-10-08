debug = require('debug')("cobudget-ui:actions")

module.exports = ->
  budgets: require('budgets/actions.coffee')
