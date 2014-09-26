debug = require('debug')("cobudget-ui:actions")

module.exports =

  navigate: (path) ->
    debug("dispatch navigate to path_update", path)
    @dispatch("path_update", path)
