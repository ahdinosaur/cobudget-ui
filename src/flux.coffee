Fluxxor = require('fluxxor')

stores = require('./stores.coffee')
actions = require('./actions.coffee')

module.exports = () ->
  new Fluxxor.Flux(stores(), actions())
