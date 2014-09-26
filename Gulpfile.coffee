gulp = require('gulp')
source = require('vinyl-source-stream')
buffer = require('vinyl-buffer')
util = require('gulp-util')
plumber = require('gulp-plumber')
sourcemaps = require('gulp-sourcemaps')
extend = require('extend')

refresh = require('gulp-livereload')
lrServer = require('tiny-lr')()

env = process.env
nodeEnv = env.NODE_ENV

lr = undefined

#
# styles
#
less = require('gulp-less')
autoprefix = require('gulp-autoprefixer')

styles = ->
  gulp.src('./src/*.less')
    .pipe(plumber())
    .pipe(sourcemaps.init())
    .pipe(less(
      paths: ['./src', './node_modules/bootstrap/less']
    ))
    .pipe(autoprefix(
      browsers: ['> 1%', 'last 2 versions']
    ))
    .pipe(sourcemaps.write('./maps'))
    .pipe(gulp.dest('./build'))
    .pipe(if lr then require('gulp-livereload')(lr) else util.noop())

gulp.task 'styles-build', styles
gulp.task 'styles-watch', ->
  gulp.watch('src/**/*.less', ['styles-build'])

#
# scripts
#
browserify = require('browserify')
mold = require('mold-source-map')

scripts = (isWatch) ->
  ->
    plugin = (bundler) ->
      bundler
        .plugin(require('bundle-collapser/plugin'))

    bundle = (bundler) ->
      bundler.bundle()
        .on('error', util.log.bind(util, "browserify error"))
        .pipe(mold.transformSourcesRelativeTo('./src'))
        .pipe(source('bundle.js'))
        .pipe(buffer())
        .pipe(sourcemaps.init(loadMaps: true))
        .pipe(if nodeEnv == 'production' then require('gulp-uglify')() else util.noop())
        .pipe(sourcemaps.write('./maps'))
        .pipe(gulp.dest('./build'))
        .pipe(if lr then require('gulp-livereload')(lr) else util.noop())

    args = {
      entries: ['.']
      debug: true
      cwd: __dirname + '/src'
    }

    if (isWatch)
      watchify = require('watchify')
      bundler = plugin(watchify(browserify(extend(args, watchify.args))))
      rebundle = -> bundle(bundler)
      bundler.on('update', rebundle)
      bundler.on('log', console.log.bind(console))
      rebundle()
    else
      bundle(plugin(browserify(args)))

gulp.task 'scripts-build', scripts(false)
gulp.task 'scripts-watch', scripts(true)

#
# server
#

server = (cb) ->
  webapp = require('./src/server.coffee')()
  webapp.listen(env.PORT or 5000, cb)

gulp.task('server', server)

#
# livereload
#

livereload = (cb) ->
  lr = require('tiny-lr')()
  lr.listen(env.LIVERELOAD_PORT or 35729, cb)

gulp.task('livereload', livereload)

# prod tasks
gulp.task('build', ['scripts-build', 'styles-build'])

# dev tasks
gulp.task('watch', ['scripts-watch', 'styles-watch'])
gulp.task('develop', ['livereload', 'watch', 'server'])

gulp.task('default', ['server'])
