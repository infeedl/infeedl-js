describe "creatives", ->
  beforeEach ->
    @node = $("<div></div>")
    document.body.appendChild(@node[0])

  afterEach ->
    document.body.removeChild(@node[0])

  describe "hidden", ->
    beforeEach ->
      jasmine.Ajax.stubRequest("/creative?placement_id=00000000-0000-4000-8000-000000000101").andReturn(AjaxFixtures.fail)

      @placement = new Infeedl.Placement("00000000-0000-4000-8000-000000000101", @node[0])
      @placement.fetch()

    it "hides", ->
      expect(@node).toBeEmpty()
      expect(@node).toHaveClass "infeedl--hidden"

  describe "external article", ->
    beforeEach ->
      jasmine.Ajax.stubRequest("/creative?placement_id=00000000-0000-4000-8000-000000000101").andReturn($.extend(
        AjaxFixtures.success,
        AjaxFixtures.creative.sample_article
      ))

      @placement = new Infeedl.Placement("00000000-0000-4000-8000-000000000101", @node[0])
      @placement.fetch()

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

    describe "instant view", ->
      beforeEach (done) ->
        setTimeout((->
          @request = jasmine.Ajax.requests.mostRecent()
          done()
        ).bind(this), 1100)

      it "tracks", ->
        expect(@request.url).toEqual "/events"
        expect(@request.params).toEqual "events%5Btype%5D=view&events%5Blinks%5D%5Bplacement%5D=00000000-0000-4000-8000-000000000101&events%5Blinks%5D%5Bcreative%5D=00000000-0000-4000-8000-00000000201"

    describe "later view", ->
      beforeEach ->
        @node.css("marginTop", "2000px")

      it "tracks", (done) ->
        setTimeout((->
          @request = jasmine.Ajax.requests.mostRecent()
          expect(@request.url).toEqual "/creative?placement_id=00000000-0000-4000-8000-000000000101"

          @node.css("marginTop", "200px")

          setTimeout((->
            @request = jasmine.Ajax.requests.mostRecent()
            expect(@request.url).toEqual "/events"
            expect(@request.params).toEqual "events%5Btype%5D=view&events%5Blinks%5D%5Bplacement%5D=00000000-0000-4000-8000-000000000101&events%5Blinks%5D%5Bcreative%5D=00000000-0000-4000-8000-00000000201"

            done()
          ).bind(this), 1100)
        ).bind(this), 1100)

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

      @placement = new Infeedl.Placement("00000000-0000-4000-8000-000000000101", @node[0])
      @placement.fetch()

    it "renders", ->
      result = """
<div class="infeedl--creative infeedl--video infeedl--appearance--horizontal">
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
      expect(computedStyle(@node.find(".infeedl--link-image"), "display")).toEqual "block"

    describe "instant view", ->
      beforeEach (done) ->
        setTimeout((->
          @request = jasmine.Ajax.requests.mostRecent()
          done()
        ).bind(this), 1100)

      it "tracks", ->
        expect(@request.url).toEqual "/events"
        expect(@request.params).toEqual "events%5Btype%5D=view&events%5Blinks%5D%5Bplacement%5D=00000000-0000-4000-8000-000000000101&events%5Blinks%5D%5Bcreative%5D=00000000-0000-4000-8000-00000000201"

    describe "click", ->
      beforeEach ->
        Infeedl.$("[data-infeedl-events-click]:first").trigger("click")
        @request = jasmine.Ajax.requests.mostRecent()

      afterEach ->
        clearInterval(@interval)

      it "tracks", (done) ->
        expect(@request.url).toEqual "/events"
        expect(@request.params).toEqual "events%5Btype%5D=click&events%5Blinks%5D%5Bplacement%5D=00000000-0000-4000-8000-000000000101&events%5Blinks%5D%5Bcreative%5D=00000000-0000-4000-8000-00000000201"

        @interval = setInterval((->
          return done() if $(".infeedl--embedded").length == 0
        ).bind(this), 300)

      describe "lifecycle", ->
        it "appends embedded and loader", (done) ->
          expect($("body")).toContainElement ".infeedl--embedded"
          expect($("body")).toContainElement ".infeedl--embedded--loader"

          expect($(".infeedl--embedded")).toHaveAttr "src", "http://cdn.infeedl.com/shared/creatives/self-closing-embedded.html"

          @interval = setInterval((->
            return done() if $(".infeedl--embedded").length == 0
          ).bind(this), 300)

        it "removes loader", (done) ->
          checked = false
          @interval = setInterval((->
            return done() if checked && $(".infeedl--embedded").length == 0

            if $(".infeedl--embedded--loader").length == 0
              expect($("body")).toContainElement ".infeedl--embedded"
              checked = true
          ).bind(this), 300)

        it "removes embedded", (done) ->
          @interval = setInterval((->
            if $(".infeedl--embedded").length == 0
              expect($("body")).not.toContainElement ".infeedl--embedded--loader"
              done()
          ).bind(this), 300)
