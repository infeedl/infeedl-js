@Infeedl ||= {}

@Infeedl.init = ->
  Infeedl.$("[data-infeedl-placement]").each ->
    placement = new Infeedl.Placement($(this).attr("data-infeedl-placement"), this)
    placement.fetch()

Infeedl.$ = jQuery.noConflict()
@Infeedl.init()
