@Infeedl ||= {}

@Infeedl.init = ->
  Zepto("[data-infeedl-placement]").each ->
    new Infeedl.Placement(this)

@Infeedl.init()
