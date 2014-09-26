gulp = require('gulp')
source = require('vinyl-source-stream')
util = require('gulp-util')
plumber = require('gulp-plumber')

refresh = require('gulp-livereload')
lrServer = require('tiny-lr')()

env = process.env

lr = undefined

#
# styles
#
less = require('gulp-less')
autoprefix = require('gulp-autoprefixer')

styles = ->
  gulp.src('./src/index.less')
    .pipe(plumber())
    .pipe(less(
      paths: ['./src', './node_modules/bootstrap/less']
    ))
    .pipe(autoprefix(
      browsers: ['> 1%', 'last 2 versions']
    ))
    .pipe(gulp.dest('./build'))
    .pipe(if lr then require('gulp-livereload')(lr) else util.noop())

gulp.task 'styles-build', styles
gulp.task 'styles-watch', ->
  gulp.watch('./src/**/*.less', ['styles-build'])

#
# scripts
#
browserify = require('browserify')

scripts = (isWatch) ->
  ->
    bundle = (bundler) ->
      bundler.bundle()
        .on('error', util.log.bind(util, "browserify error"))
        .pipe(source('bundle.js'))
        .pipe(gulp.dest('./build'))
        .pipe(if lr then require('gulp-livereload')(lr) else util.noop())

    if (isWatch)
      watchify = require('watchify')
      bundler = watchify(browserify('.', watchify.args))
      rebundle = -> bundle(bundler)
      bundler.on('update', rebundle)
      bundler.on('log', console.log.bind(console))
      rebundle()
    else
      bundle(browserify('.'))

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
