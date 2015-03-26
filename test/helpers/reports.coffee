if !_phantom?
  jasmine.getEnv().addReporter(new jasmine.JSReporter2())

  reportInterval = setInterval(->
    report = window.jasmine.getJSReport()
    if report
      window.global_test_results =
        passed: if report.passed then 1 else 0
        failed: if report.passed then 0 else 1
        total: 1
        duration: report.durationSec
        tests: [{
          name: "the suite"
          result: report.passed
          message: "the message"
          duration: report.durationSec
        }]
  , 1000)
