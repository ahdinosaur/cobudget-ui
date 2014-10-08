# @cjsx React.DOM

React = require('react')

Flux = require('./flux.coffee')
Routes = require('app')

if process.env.NODE_ENV isnt 'production'
  require('debug').enable("*")

# append main element to body if not there
if not document.querySelector('main')
  mainEl = document.createElement("main")
  document.body.appendChild(mainEl)

# require jquery
global.jQuery = require('jquery')
# require bootstrap
require('bootstrap-sass/assets/javascripts/bootstrap')

flux = Flux()

React.renderComponent(
  Routes(flux)
  document.querySelector('main')
)
