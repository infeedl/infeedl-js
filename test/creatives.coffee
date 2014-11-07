describe "creatives", ->
  beforeEach ->
    @node = Zepto("<div></div>")
    @node.attr("data-infeedl-placement", "00000000-0000-0000-0000-00000000101")
    document.body.appendChild(@node[0])

  afterEach ->
    document.body.removeChild(@node[0])

  describe "hidden", ->
    beforeEach ->
      jasmine.Ajax.stubRequest("/creative?placement_id=00000000-0000-0000-0000-00000000101").andReturn(AjaxFixtures.fail)
      @placement = new Infeedl.Placement(@node[0])

    it "hides", ->
      expect(@node).toBeEmpty()
      expect(@node).toHaveClass "infeedl--hidden"

  describe "article", ->
    beforeEach ->
      jasmine.Ajax.stubRequest("/creative?placement_id=00000000-0000-0000-0000-00000000101").andReturn(Zepto.extend(
        AjaxFixtures.success,
        AjaxFixtures.creative.sample_article
      ))
      @placement = new Infeedl.Placement(@node[0])

    it "renders", ->
      result = """
<div class="infeedl--creative infeedl--article">
  <a class="infeedl--link-image" href="http://advertiser.com/sample-article" target="_blank" data-infeedl-events-click="">
    <img class="infeedl--image" src="//cdn.infeedl.com/shared/creatives/sample-image.jpg" alt="WOW">
  </a>
  <p class="infeedl--brand">Supported by Brandname</p>
  <h3 class="infeed--title">
    <a class="infeedl--link-title" href="http://advertiser.com/sample-article" target="_blank" data-infeedl-events-click="">
      WOW
    </a>
  </h3>
</div>
      """
      expect(@node).toContainHtml result

    it "styles", ->
      expect(@node).toHaveId "infeedl-placement-00000000-0000-0000-0000-00000000101"
      expect(computedStyle(@node.find(".infeedl--brand"), "color")).toEqual "rgb(255, 165, 0)"

    describe "click", ->
      beforeEach ->
        @node.find("[data-infeedl-events-click]").trigger("click")
        @request = jasmine.Ajax.requests.mostRecent()

      it "tracks", ->
        expect(@request.url).toEqual "/event"
        expect(@request.params).toEqual "events%5Btype%5D=click&events%5Blinks%5D%5Bplacement%5D=00000000-0000-0000-0000-00000000101&events%5Blinks%5D%5Bcreative%5D=00000000-0000-0000-0000-00000000201"

  describe "video", ->
    beforeEach ->
      jasmine.Ajax.stubRequest("/creative?placement_id=00000000-0000-0000-0000-00000000101").andReturn(Zepto.extend(
        AjaxFixtures.success,
        AjaxFixtures.creative.sample_video
      ))
      @placement = new Infeedl.Placement(@node[0])

    it "renders", ->
      result = """
<div class="infeedl--creative infeedl--video">
  <a class="infeedl--link-image" href="http://advertiser.com/sample-article" target="_blank" data-infeedl-events-click="">
    <img class="infeedl--image" src="//cdn.infeedl.com/shared/creatives/sample-image.jpg" alt="WOW">
  </a>
  <p class="infeedl--brand">Supported by Brandname</p>
  <h3 class="infeed--title">
    <a class="infeedl--link-title" href="http://advertiser.com/sample-article" target="_blank" data-infeedl-events-click="">
      WOW
    </a>
  </h3>
</div>
      """
      expect(@node).toContainHtml result

    it "styles", ->
      expect(@node).toHaveId "infeedl-placement-00000000-0000-0000-0000-00000000101"
      expect(computedStyle(@node.find(".infeedl--link-image"), "display")).toEqual "inline-block"
