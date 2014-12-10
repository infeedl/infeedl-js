@Infeedl ||= {}

class @Infeedl.Placement
  @_css: """
/* COMMON */
.infeedl--creative:before, .infeedl--creative:after {
  display: table;
  content: " ";
}

.infeedl--creative:after {
  clear: both;
}

.infeedl--creative .infeedl--link-image {
  display: block;
}

.infeedl--creative .infeedl--link-image img {
  display: block;
  max-width: 100%;
  height: auto;
}

.infeedl--creative .infeedl--brand {
  display: inline-block;
  padding: 5px 10px;
  margin: 0;
  background: #ffa60d;
}

.infeedl--creative .infeedl--title {
  margin: 15px 0 0 0;
  padding: 0;
  font-size: 150%;
}

.infeedl--creative .infeedl--title .infeedl--link-title,
.infeedl--creative .infeedl--title .infeedl--link-title:hover {
  color: #000;
}

/* VIDEO */
.infeedl--video .infeedl--link-image {
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
  bottom: 10px;
  left: 10px;
}

/* HORIZONTAL */
.infeedl--appearance--horizontal {
  padding: 10px 15px;
  background: #fff;
  border: 1px solid #FFA60D;
  border-radius: 5px;
}

.infeedl--appearance--horizontal .infeedl--link-image {
  float: left;
  max-width: 20%;
  margin-right: 15px;
}

.infeedl--appearance--horizontal.infeedl--video .infeedl--link-image::after {
  width: 32px;
  height: 32px;
  background-size: 32px;
}

/* SQUARE, VERTICAL */
.infeedl--appearance--square .infeedl--title,
.infeedl--appearance--vertical .infeedl--title {
  margin-bottom: 15px;
}

.infeedl--appearance--square .infeedl--link-image,
.infeedl--appearance--vertical .infeedl--link-image {
  margin-bottom: 15px;
}

/* OVERLAY */
.infeedl--embedded, .infeedl--embedded--loader {
  display: block;
  position: absolute;
  position: fixed;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 2147483645;
}

.infeedl--embedded--loader {
  background: rgba(255, 255, 255, .5) url(//cdn.infeedl.com/shared/creatives/loader.gif) no-repeat center center;
}
  """

  constructor: (node) ->
    @node = Infeedl.$(node)
    @id = @node.attr("data-infeedl-placement")
    @creative = null
    @placement = null
    @viewed = false

    @node.attr("id", "infeedl-placement-#{@id}")
    @_client = new Infeedl.Client
    @_retrieve()

  _sample: ->
    location.hash == "#infeedl_sample"

  _retrieve: ->
    params = { placement_id: @id }
    params = Infeedl.$.extend(params, sample: true) if @_sample()

    @_client.get("/creative", params).done(((data) ->
      @placement = data.linked.placements
      @creative = new Infeedl.Creative(data.creatives.format, data.creatives, @placement)
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
    # Set up polling for visibility
    @interval = setInterval(@_visible.bind(this), 1000)

    # Clicking on clickable elements
    @node.on("click", "[data-infeedl-events-click]", ((evt) ->
      @_event("click")
      @creative.click(evt)
    ).bind(this))

  _visible: ->
    if !@viewed && @node.is(":in-viewport")
      clearInterval(@interval) if @interval
      @viewed = true
      @_event("view")

  _event: (type) ->
    event = { type: type, links: { placement: @id, creative: @creative.creative.id } }
    @_client.post("/events", events: event).done(((data) ->
      # Cool
    ).bind(this)).fail(( ->
      console?.error(arguments...)
    ).bind(this))
