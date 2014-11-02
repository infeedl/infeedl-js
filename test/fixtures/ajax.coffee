Infeedl.Client._base = ""
jasmine.Ajax.install()

@AjaxFixtures =
  common:
    status: "200"
    contentType: "application/json"
  creative:
    sample_article:
      responseText: JSON.stringify(
        creatives:
          id: 2
          format: "article"
          title: "WOW"
          link: "http://advertiser.com/sample-article"
      )
