# @cjsx React.DOM

debug = require('debug')("cobudget-ui:components:Nav")
React = require('react')
_ = require('lodash')

FluxChildMixin = require('fluxxor').FluxChildMixin(React)

Link = require('./Link.coffee')

module.exports = React.createClass
  mixins: [FluxChildMixin]

  render: ->
    debug("render'ing Nav", @props)

    return (
      <nav>
        <Link
          href="/budgets"
          className={if @props.path == 'budgets' then 'active' else ''}
        >
          budgets
        </Link>
      </nav>
    )
