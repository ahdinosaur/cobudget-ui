fs = require('fs')
http = require('http')
url = require('url')
express = require('express')
React = require('react')
Router = require('react-router')

require('./coffee')

Routes = require('app')
Flux = require('./flux.coffee')

env = process.env
nodeEnv = env.NODE_ENV or 'development'

if env.NODE_ENV isnt 'production'
  require('debug').enable("*")

module.exports = (options) ->
  options or= {}

  webapp = express()

  # add livereload middleware if dev
  if (nodeEnv == 'development')
    webapp.use(require('connect-livereload')({
      port: env.LIVERELOAD_PORT or 35729
    }))

  webapp.use(require('ecstatic')({
    root: options.root or __dirname + '/../build'
    cache: options.cache or
      if env.NODE_ENV == 'production' then 3600 else 0
    showDir: false
    autoIndex: false
  }))

  index = fs.readFileSync(__dirname + '/index.html')

  # Cached regex for stripping a leading hash/slash and trailing space.
  routeStripper = /^[#\/]|\s+$/g
  # cached regex for replacing main content
  mainContent = /<!-- CONTENT -->/

  webapp.use (req, res, next) ->
    try
      path = url.parse(req.url).pathname
      path = path.replace(routeStripper, '')
      
      ###
      don't actually render on server for now
      flux = Flux()
      routes = Routes(flux, path)
      content = Router.renderRoutesToString(routes)
      ###
      content = ""

      end = index.toString().replace(mainContent, content)
      res.status(200).send(end)

    catch err
      return next(err)

  http.createServer(webapp)
