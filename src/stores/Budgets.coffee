debug = require('debug')("cobudget-ui:stores:Budgets")
Fluxxor = require('fluxxor')

module.exports = Fluxxor.createStore({
  initialize: ->
    @budgets = [{
      name: "oh my god"
    }]
})
