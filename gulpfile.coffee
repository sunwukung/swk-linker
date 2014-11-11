gulp = require 'gulp'
gutil = require 'gulp-util'
coffee = require 'gulp-coffee'
mocha = require 'gulp-mocha'


gulp.task 'test', () ->
  return gulp.src([
    "test/**/*"
    ])
    .pipe(mocha({
      ui: "bdd",
      reporter: "spec"
      bail: true,
      compilers: "coffee:coffee-script/register"
      recursive: true
    }))

gulp.task 'test-watch', ->
  gulp.watch [
    'lib/**',
    'test/**'
    ], ['test']

gulp.task 'lint', ->
  coffeelint = require 'gulp-coffeelint'
  gulp.src(['src/**/*.coffee', 'lib/**/*.coffee'])
    .pipe(coffeelint())
    .pipe(coffeelint.reporter())

gulp.task 'default', ['test-watch']
