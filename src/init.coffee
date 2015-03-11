@Infeedl ||= {}

@Infeedl.init = ->
  Infeedl.$("[data-infeedl-placement]").each ->
    placement = new Infeedl.Placement(Infeedl.$(this).attr("data-infeedl-placement"), this)
    placement.fetch()

@Infeedl.$ = jQuery.noConflict(true)
@Infeedl.SharedYandex = new Infeedl.Yandex()
@Infeedl.init()
