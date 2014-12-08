@Infeedl ||= {}

class @Infeedl.Creative
  constructor: (@format, @creative, @placement) ->

  render: ->
    InfeedlTemplates[@format].render(@_interpolations())

  click: (evt) ->
    if @creative.content.embedded
      @_append_embedded()
      false
    else
      true

  _append_embedded: ->
    @loader = document.createElement("div")
    @loader.setAttribute("class", "infeedl--embedded--loader")
    Infeedl.$("body")[0].appendChild(@loader)

    @iframe = document.createElement("iframe")
    @iframe.setAttribute("src", @creative.content.embedded_location)
    @iframe.setAttribute("frameBorder", "0")
    @iframe.setAttribute("allowtransparency", "true")
    @iframe.setAttribute("class", "infeedl--embedded")
    Infeedl.$("body")[0].appendChild(@iframe)
    # console?.log("[INFEEDL] Creative ##{@creative.id}: embedded added")

    talker = new Talker(@iframe.contentWindow, "*")
    talker.onMessage = ((message) ->
      if message.namespace == "infeedl"
        if message.data.state == "loaded"
          @_remove_loader()
        if message.data.state == "closed"
          @_remove_embedded()
    ).bind(this)

  _remove_loader: ->
    @loder = null
    Infeedl.$(".infeedl--embedded--loader").remove()
    # console?.log("[INFEEDL] Creative ##{@creative.id}: loader removed")

  _remove_embedded: ->
    @iframe = null
    Infeedl.$(".infeedl--embedded").remove()
    # console?.log("[INFEEDL] Creative ##{@creative.id}: embedded removed")

  _interpolations: ->
    creative: @creative
    placement: @placement
