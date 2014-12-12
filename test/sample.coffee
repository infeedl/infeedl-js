describe "sample", ->
  beforeEach ->
    location.hash = "#infeedl_sample"

    @node = document.createElement("div")
    document.body.appendChild(@node)

    @placement = new Infeedl.Placement("00000000-0000-4000-8000-000000000101", @node)
    @placement.fetch()

  afterEach ->
    location.hash = ""
    document.body.removeChild(@node)

  it "renders", ->
    @request = jasmine.Ajax.requests.mostRecent()
    expect(@request.url).toEqual "/creative?placement_id=00000000-0000-4000-8000-000000000101&sample=true"
