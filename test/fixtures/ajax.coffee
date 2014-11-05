Infeedl.Client._base = ""
jasmine.Ajax.install()

@AjaxFixtures =
  success:
    status: "200"
    contentType: "application/json"
  fail:
    status: "500"
    contentType: "application/json"
  creative:
    sample_article:
      responseText: JSON.stringify(
        creatives:
          id: 2
          format: "article"
          title: "WOW"
          link: "http://advertiser.com/sample-article"
          brand: "Supported by Brandname"
          image_url: "//cdn.infeedl.com/image.jpg"
      )
