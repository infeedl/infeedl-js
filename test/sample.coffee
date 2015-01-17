describe "sample", ->
  beforeEach ->
    @node = $("<div></div>")
    document.body.appendChild(@node[0])

  afterEach ->
    location.hash = ""
    document.body.removeChild(@node[0])

  describe "simple", ->
    beforeEach ->
      location.hash = "#infeedl_sample"
      jasmine.Ajax.stubRequest("/creative?placement_id=00000000-0000-4000-8000-000000000101&sample=true").andReturn(AjaxFixtures.fail)

      placement = new Infeedl.Placement("00000000-0000-4000-8000-000000000101", @node[0])
      placement.fetch()

    it "renders", ->
      request = jasmine.Ajax.requests.mostRecent()
      expect(request.url).toEqual "/creative?placement_id=00000000-0000-4000-8000-000000000101&sample=true"

  describe "with parameter", ->
    beforeEach ->
      location.hash = "#infeedl_sample=00000000-0000-4000-8000-00000000201"
      jasmine.Ajax.stubRequest("/creative?placement_id=00000000-0000-4000-8000-000000000102&sample=00000000-0000-4000-8000-00000000201").andReturn(AjaxFixtures.fail)

      placement = new Infeedl.Placement("00000000-0000-4000-8000-000000000102", @node[0])
      placement.fetch()

    it "renders", ->
      request = jasmine.Ajax.requests.mostRecent()
      expect(request.url).toEqual "/creative?placement_id=00000000-0000-4000-8000-000000000102&sample=00000000-0000-4000-8000-00000000201"
