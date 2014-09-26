# @cjsx React.DOM

debug = require('debug')("cobudget-ui:components:Link")
React = require('react')
invariant = require('react/lib/invariant')

FluxChildMixin = require('fluxxor').FluxChildMixin(React)

Link = React.createClass
  mixins: [FluxChildMixin]

  propTypes:
    href: React.PropTypes.string

  onClick: (e) ->
    e.preventDefault()
    @navigate(@href())

  href: ->
    if (@props.href)
      return @props.href
    else
      invariant(
        false,
        'provide "href" prop to Link component'
      )

  navigate: (path) ->
    @getFlux().actions.navigate(path)

  render: ->
    return (
      <a href={@href()} onClick={@onClick}>
        {@props.children}
      </a>
    )

module.exports = Link
