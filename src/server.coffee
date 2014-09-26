fs = require('fs')
http = require('http')
url = require('url')
express = require('express')
browserify = require('browserify-middleware')
React = require('react')

App = require('./components/App.coffee')
Flux = require('./Flux.coffee')

if process.env.NODE_ENV isnt 'production'
  require('debug').enable("*")

webapp = express()

engines = require('consolidate')
webapp.engine('eco', engines.eco)
webapp.set('views', __dirname + '/views')
webapp.set('view engine', 'eco')

# Cached regex for stripping a leading hash/slash and trailing space.
routeStripper = /^[#\/]|\s+$/g

webapp.get('/bundle.js', browserify(__dirname + '/../client.js'))

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

server = http.createServer(webapp)
server.listen(5000)
