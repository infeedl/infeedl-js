Infeedl.Client._base = ""
jasmine.Ajax.install()
jasmine.DEFAULT_TIMEOUT_INTERVAL = 10000

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
          id: "00000000-0000-4000-8000-00000000201"
          format: "article"
          title: "WOW"
          brand: "Supported by Brandname"
          picture: "//cdn.infeedl.com/shared/creatives/sample-image.jpg"
          content:
            location: "//cdn.infeedl.com/shared/creatives/self-closing.html"
            embedded: false
            embedded_location: "//cdn.infeedl.com/shared/creatives/self-closing.html"
        linked:
          placements: {
            id: "00000000-0000-4000-8000-000000000101"
            appearance: "horizontal",
            stylesheet: """
#infeedl-placement-00000000-0000-4000-8000-000000000101 .infeedl--brand {
  color: orange;
}
            """
          }
      )
    sample_video:
      responseText: JSON.stringify(
        creatives:
          id: "00000000-0000-4000-8000-00000000201"
          format: "video"
          title: "WOW"
          brand: "Supported by Brandname"
          picture: "//cdn.infeedl.com/shared/creatives/sample-image.jpg"
          content:
            location: "//cdn.infeedl.com/shared/creatives/self-closing.html"
            embedded: true
            # FIXME: protocol-less URL doesn't work in Phantom
            embedded_location: "http://cdn.infeedl.com/shared/creatives/self-closing-embedded.html"
        linked:
          placements: {
            id: "00000000-0000-4000-8000-000000000101"
            appearance: "horizontal",
            stylesheet: """
#infeedl-placement-00000000-0000-4000-8000-000000000101 .infeedl--brand {
  color: orange;
}
            """
          }
      )
