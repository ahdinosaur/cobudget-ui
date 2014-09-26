# @cjsx React.DOM

React = require('react')

Flux = require('./Flux.coffee')
App = require('./components/App.coffee')

require('./index.css')

if process.env.NODE_ENV isnt 'production'
  require('debug').enable("*")

# append main element to body if not there
if not document.querySelector('main')
  mainEl = document.createElement("main")
  document.body.appendChild(mainEl)

flux = Flux()

React.renderComponent(
  <App flux={flux} />
  document.querySelector('main')
)