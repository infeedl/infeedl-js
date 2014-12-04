@Infeedl ||= {}

class @Infeedl.Placement
  @_css: """
/* VIDEO */
.infeedl--video .infeedl--link-image {
  display: inline-block;
  position: relative;
  text-decoration: none;
}

.infeedl--video .infeedl--link-image::after {
  display: inline-block;
  content: "";
  width: 48px;
  height: 48px;
  background: url(//cdn.infeedl.com/shared/creatives/icon-play@2x.png);
  background-size: 48px 48px;
  position: absolute;
  bottom: 15px;
  left: 15px;
}
  """

  constructor: (node) ->
    @node = Infeedl.$(node)
    @id = @node.attr("data-infeedl-placement")
    @creative = null
    @placement = null

    @node.attr("id", "infeedl-placement-#{@id}")
    @_client = new Infeedl.Client
    @_retrieve()

  _sample: ->
    location.hash == "#infeedl_sample"

  _retrieve: ->
    params = { placement_id: @id }
    params = Infeedl.$.extend(params, sample: true) if @_sample()

    @_client.get("/creative", params).done(((data) ->
      format = data.creatives.format
      Creative = Infeedl.Creatives["#{format.charAt(0).toUpperCase()}#{format.slice(1)}"]

      @placement = data.linked.placements
      @creative = new Creative(data.creatives, @placement)
      @_render()
    ).bind(this)).fail(( ->
      @_fail()
    ).bind(this))

  _css: (id, stylesheet) ->
    return if Infeedl.$("##{id}").length > 0

    style = document.createElement("style")
    style.id = id
    style.type = "text/css"

    if style.styleSheet
      style.styleSheet.cssText = stylesheet
    else
      style.appendChild(document.createTextNode(stylesheet))

    Infeedl.$("head")[0].appendChild(style)

  _render: ->
    @_css("infeedl-base-stylesheet", @constructor._css)
    @_css("infeedl-placement-#{@id}-stylesheet", @placement.stylesheet)
    @node.html(@creative.render(@placement))
    @_bind()

  _fail: ->
    @node.addClass("infeedl--hidden")

  _bind: ->
    @node.on("click", "[data-infeedl-events-click]", (->
      @_event("click")
      true
    ).bind(this))

  _event: (type) ->
    event = { type: type, links: { placement: @id, creative: @creative.creative.id } }
    @_client.post("/event", events: event).done(((data) ->
      # Cool
    ).bind(this)).fail(( ->
      console?.error(arguments...)
    ).bind(this))
