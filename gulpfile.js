var gulp         = require("gulp");
var sass         = require("gulp-sass");
var plumber      = require("gulp-plumber");
var autoprefixer = require("gulp-autoprefixer");
var uglify       = require("gulp-uglify");
var minifyCSS    = require("gulp-minify-css");
var browserify   = require("browserify");
var source       = require("vinyl-source-stream");
var run          = require("run-sequence");
var del          = require("del");

gulp.task("js", function() {
  gulp.src("assets/javascripts/**/*.js")
  .pipe(plumber())
  .pipe(uglify())
  .pipe(gulp.dest("public/js"));
});

gulp.task("css", function() {
  gulp.src("assets/stylesheets/**/*.css")
  .pipe(plumber())
  .pipe(autoprefixer())
  .pipe(minifyCSS({keepBreaks: true}))
  .pipe(gulp.dest("public/css"));
});

gulp.task("scss", function() {
  gulp.src("assets/stylesheets/**/*.scss")
  .pipe(plumber())
  .pipe(sass())
  .pipe(autoprefixer())
  .pipe(minifyCSS({keepBreaks: true}))
  .pipe(gulp.dest("public/css"));
});

gulp.task("clean", function(cb) {
  del(["public/js", "public/css"], cb)
});

gulp.task("build", function() {
  run(
    "js",
    "css",
    "scss"
  );
});

gulp.task("watch", function() {
  gulp.watch("assets/javascripts/**/*.js", ["js"]);
  gulp.watch("assets/stylesheets/**/*.css", ["css"]);
  gulp.watch("assets/stylesheets/**/*.scss", ["scss"]);
});

gulp.task("default", function() {
  run(
    "clean",
    "build",
    "watch"
  );
});
