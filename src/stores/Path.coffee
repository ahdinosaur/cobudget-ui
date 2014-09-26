debug = require('debug')("cobudget-ui:stores:Path")
Fluxxor = require('fluxxor')
LocationBar = require('location-bar')

locationBar = new LocationBar()

module.exports = Fluxxor.createStore
  
  actions:
    "path_update": "onUpdate"

  initialize: (path) ->
    
    @path = path

    if process.browser
      locationBar.onChange(((path) ->
        debug("onChange", path)

        @path = path

        @emit("change")

      ).bind(this))

      locationBar.start pushState: true

  onUpdate: (path) ->

    locationBar.update path, trigger: true