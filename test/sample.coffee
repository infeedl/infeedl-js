describe "sample", ->
  beforeEach ->
    location.hash = "#infeedl_sample"
    @node = document.createElement("div")
    @node.setAttribute("data-infeedl-placement", "1")
    document.body.appendChild(@node)
    @placement = new Infeedl.Placement(@node)

  afterEach ->
    location.hash = ""
    document.body.removeChild(@node)

  it "renders", ->
    @request = jasmine.Ajax.requests.mostRecent()
    expect(@request.url).toEqual "/creative?placement_id=1&sample=true"
