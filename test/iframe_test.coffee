describe "iframe", ->
  beforeEach ->
    @iframe = new Infeedl.Iframe()

  it "can run height", ->
    @iframe.height()

  it "can run action", ->
    @iframe.action()
