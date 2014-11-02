module.exports = (grunt) ->
  # Configuration
  grunt.initConfig
    # Package information
    pkg: grunt.file.readJSON("package.json")

    # Coffee
    coffee:
      infeedl:
        files:
          "src/infeedl.js": [
            "src/creative.coffee"
            "src/creatives/*.coffee"
            "src/client.coffee"
            "src/placement.coffee"
            "src/init.coffee"
          ]
      test:
        options:
          bare: true
        files:
          "test/tests.js": [
            "test/fixtures/*.coffee"
            "test/*.coffee"
          ]
          "test/helpers.js": "test/helpers/*.coffee"

    # Templates
    hogan:
      infeedl:
        options:
          namespace: "InfeedlTemplates"
          defaultName: (file) ->
            file.split("/").pop().replace(".html", "")
        files:
          "src/templates.js": ["src/templates/*.html"]

    # Concat
    concat:
      infeedl:
        src: [
          "node_modules/hogan.js/lib/template.js"
          "node_modules/zepto/src/zepto.js"
          "node_modules/zepto/src/event.js"
          "node_modules/zepto/src/callbacks.js"
          "node_modules/zepto/src/deferred.js"
          "node_modules/zepto/src/ajax.js"
          "src/templates.js"
          "src/infeedl.js"
        ]
        dest: "dist/infeedl.js"

    # Uglify
    uglify:
      infeedl:
        options:
          mangle: true
          sourceMap: true
          sourceMapName: "dist/infeedl.min.map"
        files:
          "dist/infeedl.min.js": "dist/infeedl.js"

    # Jasmine
    jasmine:
      infeedl:
        src: "dist/infeedl.min.js"
        options:
          keepRunner: true
          vendor: [
            "node_modules/zepto/src/zepto.js"
            "test/helpers.js"
            "node_modules/jasmine-jquery/lib/jasmine-jquery.js"
            "node_modules/jasmine-ajax/lib/mock-ajax.js"
          ]
          specs: "test/tests.js"

  # Load tasks from plugins
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-templates-hogan"
  grunt.loadNpmTasks "grunt-contrib-concat"
  grunt.loadNpmTasks "grunt-contrib-uglify"
  grunt.loadNpmTasks "grunt-contrib-jasmine"

  # Build
  grunt.registerTask "build", ["coffee", "hogan", "concat", "uglify"]

  # Test
  grunt.registerTask "test", ["build", "jasmine"]

  # Deploy
  grunt.registerTask "deploy", ["test"]

  # Default meta-task
  grunt.registerTask "default", ["build"]
