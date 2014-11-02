describe "creatives", ->
  beforeEach ->
    @node = document.createElement("div")
    @node.setAttribute("data-infeedl-placement", "1")
    document.body.appendChild(@node)

  afterEach ->
    document.body.removeChild(@node)

  describe "article", ->
    beforeEach ->
      jasmine.Ajax.stubRequest("/creative?placement_id=1").andReturn(Zepto.extend(
        AjaxFixtures.common,
        AjaxFixtures.creative.sample_article
      ))
      @placement = new Infeedl.Placement(@node)

    it "renders", ->
      expect(Zepto(@node)).toContainHtml '<a href="http://advertiser.com/sample-article" target="_blank" data-infeedl-events-click>WOW</a>'

    describe "click", ->
      beforeEach ->
        Zepto(@node).find("[data-infeedl-events-click]").trigger("click")
        @request = jasmine.Ajax.requests.mostRecent()

      it "tracks", ->
        expect(@request.url).toEqual "/event"
        expect(@request.params).toEqual "events%5Btype%5D=click&events%5Blinks%5D%5Bplacement%5D=1&events%5Blinks%5D%5Bcreative%5D=2"
