fs = require('fs')
http = require('http')
url = require('url')
express = require('express')
browserify = require('browserify-middleware')
React = require('react')

App = require('./app.coffee')
Flux = require('./flux.coffee')

env = process.env

if env.NODE_ENV isnt 'production'
  require('debug').enable("*")

module.exports = (options) ->
  options or= {}

  webapp = express()

  # add livereload middleware if dev
  if (env.NODE_ENV == 'development')
    webapp.use(require('connect-livereload')({
      port: env.LIVERELOAD_PORT or 35729
    }))

  webapp.use(require('ecstatic')({
    root: options.root or __dirname + '/../build'
    cache: options.cache or
      if env.NODE_ENV == 'production' then 3600 else 0
  }))

  engines = require('consolidate')
  webapp.engine('eco', engines.eco)
  webapp.set('views', __dirname)
  webapp.set('view engine', 'eco')

  # Cached regex for stripping a leading hash/slash and trailing space.
  routeStripper = /^[#\/]|\s+$/g

  webapp.use (req, res, next) ->
    try
      path = url.parse(req.url).pathname
      path = path.replace(routeStripper, '')
      
      flux = Flux(path)
      app = App(path: path, flux: flux)
      content = React.renderComponentToString(app)

      res.render('index', content: content)

    catch err
      return next(err)

  http.createServer(webapp)
