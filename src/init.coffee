@Infeedl ||= {}

@Infeedl.init = ->
  Infeedl.$("[data-infeedl-placement]").each ->
    new Infeedl.Placement(this)


Infeedl.$ = jQuery.noConflict()
@Infeedl.init()
