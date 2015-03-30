describe "api", ->
  beforeEach ->
    @node = $("<div></div>")
    document.body.appendChild(@node[0])

    @results = { success: [], failure: [] }
    @options =
      onSuccess: (id) => @results.success.push(id)
      onFailure: (id) => @results.failure.push(id)

  afterEach ->
    document.body.removeChild(@node[0])

  describe "onSuccess", ->
    beforeEach ->
      jasmine.Ajax.stubRequest("/creative?placement_id=00000000-0000-4000-8000-000000000102").andReturn($.extend({},
        AjaxFixtures.success,
        AjaxFixtures.creative.sample_article
      ))

      placement = new Infeedl.Placement("00000000-0000-4000-8000-000000000102", @node[0], @options)
      placement.fetch()

    it "calls the callback", ->
      expect(@results).toEqual (success: ["00000000-0000-4000-8000-000000000102"], failure: [])

  describe "onFailure", ->
    beforeEach ->
      jasmine.Ajax.stubRequest("/creative?placement_id=00000000-0000-4000-8000-000000000102").andReturn(AjaxFixtures.fail)

      placement = new Infeedl.Placement("00000000-0000-4000-8000-000000000102", @node[0], @options)
      placement.fetch()

    it "calls the callback", ->
      expect(@results).toEqual (success: [], failure: ["00000000-0000-4000-8000-000000000102"])
