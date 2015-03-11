@Infeedl ||= {}

class @Infeedl.Creative
  constructor: (@format, @creative, @placement) ->

  render: ->
    InfeedlTemplates[@format.replace("embedded_", "")].render(@_interpolations())

  click: ->
    if @creative.content.embedded
      @_append_embedded()
    else
      @_open_content()

  _open_content: ->
    window.open(@creative.content.location)

  _append_embedded: ->
    @loader = document.createElement("div")
    @loader.setAttribute("class", "infeedl--embedded--loader")
    Infeedl.$("body").addClass("infeedl--no-scroll")
    Infeedl.$("body")[0].appendChild(@loader)

    @wrapper = document.createElement("div")
    @wrapper.setAttribute("class", "infeedl--embedded-wrapper")

    @iframe = document.createElement("iframe")
    @iframe.setAttribute("src", @creative.content.embedded_location)
    @iframe.setAttribute("frameBorder", "0")
    @iframe.setAttribute("allowtransparency", "true")
    @iframe.setAttribute("class", "infeedl--embedded")

    Infeedl.$("body")[0].appendChild(@wrapper)
    Infeedl.$(".infeedl--embedded-wrapper")[0].appendChild(@iframe)
    # console?.log("[INFEEDL] Creative ##{@creative.id}: embedded added")

    talker = new Talker(@iframe.contentWindow, "*")
    talker.onMessage = ((message) ->
      if message.namespace == "infeedl"
        if message.data.state == "loaded"
          @_remove_loader()
        if message.data.state == "closed"
          @_remove_embedded()
    ).bind(this)

    setTimeout((->
      if @loader
        @_remove_loader()
        @_remove_embedded()
    ).bind(this), 15000)

  _remove_loader: ->
    @loader = null
    Infeedl.$(".infeedl--embedded--loader").remove()

    @close = document.createElement("div")
    @close.setAttribute("class", "infeedl--embedded-close")
    Infeedl.$("body")[0].appendChild(@close)
    Infeedl.$(".infeedl--embedded-close").css(top: Infeedl.$(window).scrollTop() + 30)

    Infeedl.$(document).on("click", ".infeedl--embedded-close", @_remove_embedded)
    # console?.log("[INFEEDL] Creative ##{@creative.id}: loader removed")

  _remove_embedded: ->
    Infeedl.$(document).off("click", ".infeedl--embedded-close", @_remove_embedded)

    @close = null
    @wrapper = null
    @iframe = null

    Infeedl.$(".infeedl--embedded-close").remove()
    Infeedl.$(".infeedl--embedded-wrapper").remove()
    Infeedl.$("body").removeClass("infeedl--no-scroll")
    # console?.log("[INFEEDL] Creative ##{@creative.id}: embedded removed")

  _interpolations: ->
    creative: @creative
    placement: @placement
