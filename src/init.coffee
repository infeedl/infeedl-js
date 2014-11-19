@Infeedl ||= {}

@Infeedl.init = ->
  Infeedl.$ = jQuery.noConflict()
  Infeedl.$("[data-infeedl-placement]").each ->
    new Infeedl.Placement(this)

@Infeedl.init()
