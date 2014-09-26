# @cjsx React.DOM

debug = require('debug')("directory-ui:components:Budget")
React = require('react')
Fluxxor = require('fluxxor')

FluxChildMixin = Fluxxor.FluxChildMixin(React)

module.exports = React.createClass
  mixins: [FluxChildMixin]

  render: ->
    debug("render'ing Budget", @props.budget)

    return (
      <div>
        budget!
      </div>
    )
