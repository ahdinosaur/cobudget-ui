# @cjsx React.DOM

debug = require('debug')("cobudget-ui:components:App")
React = require('react')
Fluxxor = require('fluxxor')

Nav = require('./Nav.coffee')
Budget = require('./Budget.coffee')

FluxMixin = Fluxxor.FluxMixin(React)
StoreWatchMixin = Fluxxor.StoreWatchMixin

module.exports = React.createClass
  mixins: [FluxMixin, StoreWatchMixin("Path", "Budgets")]

  getStateFromFlux: ->
    flux = this.getFlux()
    state = {
      path: flux.store("Path").path
      budgets: flux.store("Budgets").budgets
    }

    debug("getStateFromFlux", state)

    return state

  render: ->
    debug("render'ing App", @state)

    page = <Budget
      budget={@state.budgets[0]}
    />

    return (
      <div>
        <Nav path={@state.path} />
        {page}
      </div>
    )
