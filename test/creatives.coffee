describe "creatives", ->
  beforeEach ->
    @node = $("<div></div>")
    @node.attr("data-infeedl-placement", "00000000-0000-4000-8000-000000000101")
    document.body.appendChild(@node[0])

  afterEach ->
    document.body.removeChild(@node[0])

  describe "hidden", ->
    beforeEach ->
      jasmine.Ajax.stubRequest("/creative?placement_id=00000000-0000-4000-8000-000000000101").andReturn(AjaxFixtures.fail)
      @placement = new Infeedl.Placement(@node[0])

    it "hides", ->
      expect(@node).toBeEmpty()
      expect(@node).toHaveClass "infeedl--hidden"

  describe "external article", ->
    beforeEach ->
      jasmine.Ajax.stubRequest("/creative?placement_id=00000000-0000-4000-8000-000000000101").andReturn($.extend(
        AjaxFixtures.success,
        AjaxFixtures.creative.sample_article
      ))
      @placement = new Infeedl.Placement(@node[0])

    it "renders", ->
      result = """
<div class="infeedl--creative infeedl--article infeedl--appearance--horizontal">
  <a class="infeedl--link-image" href="//cdn.infeedl.com/shared/creatives/self-closing.html" target="_blank" data-infeedl-events-click="">
    <img class="infeedl--image" src="//cdn.infeedl.com/shared/creatives/sample-image.jpg" alt="WOW">
  </a>
  <p class="infeedl--brand">Supported by Brandname</p>
  <h2 class="infeedl--title">
    <a class="infeedl--link-title" href="//cdn.infeedl.com/shared/creatives/self-closing.html" target="_blank" data-infeedl-events-click="">
      WOW
    </a>
  </h2>
</div>
      """
      expect(@node).toContainHtml result

    it "styles", ->
      expect(@node).toHaveId "infeedl-placement-00000000-0000-4000-8000-000000000101"
      expect(["rgb(255, 165, 0)", "#ffa500", "orange"]).toContain computedStyle(@node.find(".infeedl--brand"), "color")

    describe "click", ->
      beforeEach ->
        Infeedl.$("[data-infeedl-events-click]:first").trigger("click")
        @request = jasmine.Ajax.requests.mostRecent()

      it "tracks", ->
        expect(@request.url).toEqual "/events"
        expect(@request.params).toEqual "events%5Btype%5D=click&events%5Blinks%5D%5Bplacement%5D=00000000-0000-4000-8000-000000000101&events%5Blinks%5D%5Bcreative%5D=00000000-0000-4000-8000-00000000201"

  describe "embedded video", ->
    beforeEach ->
      jasmine.Ajax.stubRequest("/creative?placement_id=00000000-0000-4000-8000-000000000101").andReturn($.extend(
        AjaxFixtures.success,
        AjaxFixtures.creative.sample_video
      ))
      @placement = new Infeedl.Placement(@node[0])

    it "renders", ->
      result = """
<div class="infeedl--creative infeedl--video infeedl--appearance--horizontal">
  <a class="infeedl--link-image" href="http://cdn.infeedl.com/shared/creatives/self-closing-embedded.html" target="_blank" data-infeedl-events-click="">
    <img class="infeedl--image" src="//cdn.infeedl.com/shared/creatives/sample-image.jpg" alt="WOW">
  </a>
  <p class="infeedl--brand">Supported by Brandname</p>
  <h2 class="infeedl--title">
    <a class="infeedl--link-title" href="http://cdn.infeedl.com/shared/creatives/self-closing-embedded.html" target="_blank" data-infeedl-events-click="">
      WOW
    </a>
  </h2>
</div>
      """
      expect(@node).toContainHtml result

    it "styles", ->
      expect(@node).toHaveId "infeedl-placement-00000000-0000-4000-8000-000000000101"
      expect(computedStyle(@node.find(".infeedl--link-image"), "display")).toEqual "block"

    describe "click", ->
      beforeEach ->
        Infeedl.$("[data-infeedl-events-click]:first").trigger("click")
        @request = jasmine.Ajax.requests.mostRecent()

      it "tracks", ->
        expect(@request.url).toEqual "/events"
        expect(@request.params).toEqual "events%5Btype%5D=click&events%5Blinks%5D%5Bplacement%5D=00000000-0000-4000-8000-000000000101&events%5Blinks%5D%5Bcreative%5D=00000000-0000-4000-8000-00000000201"

      describe "lifecycle", ->
        it "appends embedded and loader", ->
          expect($("body")).toContainElement ".infeedl--embedded"
          expect($("body")).toContainElement ".infeedl--embedded--loader"

        it "removes loader", (done) ->
          setTimeout((->
            expect($("body")).not.toContainElement ".infeedl--embedded--loader"
            done()
          ).bind(this), 3000)

        it "removes embedded", (done) ->
          setTimeout((->
            expect($("body")).not.toContainElement ".infeedl--embedded"
            done()
          ).bind(this), 6000)
