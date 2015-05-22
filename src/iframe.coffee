@Infeedl ||= {}

class @Infeedl.Iframe
  constructor: (@selector = "body") ->
    @talker = new Talker(parent, "*")
    Infeedl.$(window).resize(@height.bind(this))
    Infeedl.$(@height.bind(this))

  height: ->
    @talker.send("infeedl", height: Infeedl.$(@selector).outerHeight())

  action: ->
    @talker.send("infeedl", action: true)
