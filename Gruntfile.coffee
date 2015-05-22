module.exports = (grunt) ->
  secrets = try
    grunt.file.readJSON("secrets.json")
  catch e
    {}

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
            "src/iframe.coffee"
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
          "vendor/jquery.js"
          "vendor/jquery-ajaxq.js"
          "vendor/jquery-xdomainrequest.js"
          "vendor/talker.js"
          "vendor/isInViewport.js"
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
            "vendor/jquery.js"
            "vendor/jasmine-jsreporter.js"
            "test/helpers.js"
            "node_modules/jasmine-jquery/lib/jasmine-jquery.js"
            "node_modules/jasmine-ajax/lib/mock-ajax.js"
          ]
          specs: "test/tests.js"

    # S3
    aws_s3:
      options:
        accessKeyId: secrets.AWS_KEY || process.env.AWS_KEY
        secretAccessKey: secrets.AWS_SECRET || process.env.AWS_SECRET
        region: "eu-central-1"
      jasmine:
        options:
          bucket: "infeedl"
          differential: true
        files: [
          { expand: true, src: ["_SpecRunner.html"], dest: "infeedl-js/jasmine" }
          { expand: true, cwd: ".grunt", src: ["**"], dest: "infeedl-js/jasmine/.grunt" }
          { expand: true, cwd: "dist", src: ["**"], dest: "infeedl-js/jasmine/dist" }
          { expand: true, cwd: "test", src: ["**"], dest: "infeedl-js/jasmine/test" }

          # TODO: Fetch this list
          { expand: true, src: ["vendor/jquery.js"], dest: "infeedl-js/jasmine" }
          { expand: true, src: ["vendor/jasmine-jsreporter.js"], dest: "infeedl-js/jasmine" }
          { expand: true, src: ["node_modules/jasmine-jquery/lib/jasmine-jquery.js"], dest: "infeedl-js/jasmine" }
          { expand: true, src: ["node_modules/jasmine-ajax/lib/mock-ajax.js"], dest: "infeedl-js/jasmine" }
        ]
      deploy:
        options:
          bucket: "infeedl"
          differential: true
        files: [
          { expand: true, cwd: "dist", src: ["*"], dest: "js" }
        ]

    # CloudFront invalidation
    invalidate_cloudfront:
      options:
        key: secrets.AWS_KEY || process.env.AWS_KEY
        secret: secrets.AWS_SECRET || process.env.AWS_SECRET
        distribution: "E1VO8EXH3W32T2"
      deploy:
        files: [
          { expand: true, cwd: "dist", src: ["*"], dest: "js" }
        ]

    # Saucelabs
    http:
      jasmine:
        options:
          url: "https://saucelabs.com/rest/v1/infeedl/js-tests"
          method: "POST"
          auth:
            username: "infeedl"
            password: secrets.SAUCELABS_SECRET || process.env.SAUCELABS_SECRET
          form:
            platforms: JSON.stringify([
              # iOS
              ["OS X 10.10", "iphone", "8.2"]
              ["OS X 10.10", "iphone", "8.1"]
              ["OS X 10.9", "ipad", "8.0"]
              ["OS X 10.9", "ipad", "7.0"]

              # Android
              ["Linux", "android", "5.0"]
              ["Linux", "android", "4.4"]

              # OS X 10.10
              ["OS X 10.10", "safari", "9"]
              ["OS X 10.10", "chrome", "41"]
              ["OS X 10.10", "firefox", "36"]

              # OS X 10.9
              ["OS X 10.9", "safari", "8"]

              # Linux
              ["Linux", "chrome", "41"]
              ["Linux", "firefox", "36"]
              ["Linux", "opera", "12"]

              # Win 8.1
              ["Windows 8.1", "internet explorer", "11"]

              # Win 8
              ["Windows 8", "internet explorer", "10"]

              # Win 7
              ["Windows 7", "chrome", "41"]
              ["Windows 7", "firefox", "36"]
              ["Windows 7", "opera", "12"]
            ])
            url: "http://s3.eu-central-1.amazonaws.com/infeedl/infeedl-js/jasmine/_SpecRunner.html"
            framework: "custom"
            name: "Infeedl JS"
            concurrency: 5
            build: process.env.TRAVIS_JOB_ID || "unknown"


  # Load tasks from plugins
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-templates-hogan"
  grunt.loadNpmTasks "grunt-contrib-concat"
  grunt.loadNpmTasks "grunt-contrib-uglify"
  grunt.loadNpmTasks "grunt-contrib-jasmine"
  grunt.loadNpmTasks "grunt-aws-s3"
  grunt.loadNpmTasks "grunt-invalidate-cloudfront"
  grunt.loadNpmTasks "grunt-http"

  # Build
  grunt.registerTask "build", ["coffee", "hogan", "concat", "uglify"]

  # Test
  grunt.registerTask "test", ["build", "jasmine"]

  # SauseLabs
  grunt.registerTask "saucelabs", ["aws_s3:jasmine", "http:jasmine"]

  # Deploy
  grunt.registerTask "deploy", ["aws_s3:deploy", "invalidate_cloudfront:deploy"]

  # Default meta-task
  grunt.registerTask "default", ["build"]
