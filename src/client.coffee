# @cjsx React.DOM

React = require('react')

Flux = require('./flux.coffee')
App = require('./app.coffee')

if process.env.NODE_ENV isnt 'production'
  require('debug').enable("*")

# append main element to body if not there
if not document.querySelector('main')
  mainEl = document.createElement("main")
  document.body.appendChild(mainEl)

flux = Flux()

Budgets = flux.stores.Budgets
Nav = flux.stores.Nav

# TODO move somewhere more appropriate
# once budgets are loaded, default
# path to first budget
Budgets.once "change", ->
  if Nav.path == ""
    flux.actions.nav.navigate
      name: "budget"
      params:
        budgetId: Budgets.budgets[0].id
Budgets.load()

React.renderComponent(
  <App flux={flux} />
  document.querySelector('main')
)
