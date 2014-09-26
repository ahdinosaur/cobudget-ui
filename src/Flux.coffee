Fluxxor = require('fluxxor')

stores = require('./stores/index.coffee')
actions = require('./actions.coffee')

module.exports = (path) ->
  new Fluxxor.Flux(stores(path), actions)