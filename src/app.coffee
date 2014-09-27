# @cjsx React.DOM

debug = require('debug')("cobudget-ui:components:App")
React = require('react')
Fluxxor = require('fluxxor')

NavBar = require('nav/views/bar.coffee')
Budget = require('budgets/views/one.coffee')

FluxMixin = Fluxxor.FluxMixin(React)
StoreWatchMixin = Fluxxor.StoreWatchMixin

module.exports = React.createClass
  mixins: [FluxMixin, StoreWatchMixin("Nav", "Budgets")]

  getStateFromFlux: ->
    flux = this.getFlux()
    state = {
      path: flux.store("Nav").path
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
        <NavBar path={@state.path} budgets={@state.budgets} />
        {page}
      </div>
    )
