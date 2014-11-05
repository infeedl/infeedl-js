describe "sample", ->
  beforeEach ->
    location.hash = "#infeedl_sample"
    @node = document.createElement("div")
    @node.setAttribute("data-infeedl-placement", "00000000-0000-0000-0000-00000000101")
    document.body.appendChild(@node)
    @placement = new Infeedl.Placement(@node)

  afterEach ->
    location.hash = ""
    document.body.removeChild(@node)

  it "renders", ->
    @request = jasmine.Ajax.requests.mostRecent()
    expect(@request.url).toEqual "/creative?placement_id=00000000-0000-0000-0000-00000000101&sample=true"
