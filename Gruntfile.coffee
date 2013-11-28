workDir = "build"
srcDir = "src"
testSrcDir = "test"
resourceDir = "resources"


module.exports = (grunt) ->

  grunt.initConfig

    pkg: grunt.file.readJSON "package.json"

    clean: [workDir]

    watch:
      files: [
        "Gruntfile.*"
        "#{srcDir}/**/*.coffee"
        "#{testSrcDir}/**/*.coffee"
        "#{resourceDir}/**/*"
      ]
      tasks: ["default"]

    copy:
      resources:
        files: [
          expand: true
          cwd: resourceDir
          src: ["**/*"]
          dest: workDir
        ]

    # Transcompile CoffeeScript to JavaScript files
    coffee:
      main:
        options:
          bare: true
        cwd: "#{srcDir}"
        expand: true
        src: ["**/*.coffee"]
        dest: "#{workDir}/src"
        ext: ".js"
      test:
        options:
          bare: true
        cwd: "#{testSrcDir}"
        expand: true
        src: ["**/*.coffee"]
        dest: "#{workDir}/test"
        ext: ".js"
      gruntfile:
        options:
          bare: true
        src: ["Gruntfile.coffee"]
        expand: true
        dest: "#{workDir}"
        ext: ".js"

    mochacov:
      unit:
        options:
          reporter: "spec"
      coverage:
        options:
          reporter: "mocha-term-cov-reporter"
          coverage: true
      coveralls:
        options:
          coveralls:
            serviceName: "travis-ci"
            repoToken: "vBydWgH1Jjg4EqJaYgn3mQOg0FVsXETth"
      options:
        files: "#{workDir}/test/**/*.js"

  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-copy"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-mocha-cov"


  grunt.registerTask "test", ["clean", "coffee", "mochacov"]

