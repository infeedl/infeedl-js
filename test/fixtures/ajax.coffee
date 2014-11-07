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
          id: "00000000-0000-0000-0000-00000000201"
          format: "article"
          title: "WOW"
          link: "http://advertiser.com/sample-article"
          brand: "Supported by Brandname"
          image_url: "//cdn.infeedl.com/shared/creatives/sample-image.jpg"
        linked:
          placements: {
            id: "00000000-0000-0000-0000-00000000101"
            stylesheet: """
#infeedl-placement-00000000-0000-0000-0000-00000000101 .infeedl--brand {
  color: orange;
}
            """
          }
      )
    sample_video:
      responseText: JSON.stringify(
        creatives:
          id: "00000000-0000-0000-0000-00000000201"
          format: "video"
          title: "WOW"
          link: "http://advertiser.com/sample-article"
          brand: "Supported by Brandname"
          image_url: "//cdn.infeedl.com/shared/creatives/sample-image.jpg"
        linked:
          placements: {
            id: "00000000-0000-0000-0000-00000000101"
            stylesheet: """
#infeedl-placement-00000000-0000-0000-0000-00000000101 .infeedl--brand {
  color: orange;
}
            """
          }
      )
