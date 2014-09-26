Fluxxor = require('fluxxor')

stores = require('./stores.coffee')
actions = require('./actions.coffee')

module.exports = (path) ->
  new Fluxxor.Flux(stores(path), actions)
