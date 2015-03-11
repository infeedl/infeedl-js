@Infeedl ||= {}

class @Infeedl.Placement
  @_css: """
/* COMMON */
.infeedl--creative {
  cursor: pointer;
}

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
  border: 1px solid #ccc;
}

.infeedl--creative .infeedl--brand {
  display: inline-block;
  padding: 5px 10px;
  margin: 0;
  background: #ffa60d;
}

.infeedl--creative .infeedl--title {
  margin: 8px 0 10px 0;
  padding: 0;
  font-weight: normal;
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
  background: url(//cdn.infeedl.com/shared/creatives/icon-play.png);
  background-size: 48px 48px;
  position: absolute;
  bottom: 10px;
  left: 10px;
}

/* HORIZONTAL */
.infeedl--appearance--horizontal {
  padding: 10px 15px;
  background: #fff;
  border: 2px solid #FFA60D;
  border-radius: 5px;
}

.infeedl--appearance--horizontal .infeedl--link-image {
  float: left;
  width: 20%;
  min-width: 150px;
  min-height: 112px;
  margin-right: 15px;
}

@media (max-width: 600px) {
  .infeedl--appearance--horizontal .infeedl--link-image {
    width: 100%;
    margin-bottom: 15px;
  }
}

.infeedl--appearance--horizontal.infeedl--video .infeedl--link-image::after {
  width: 32px;
  height: 32px;
  background-size: 32px;
}

/* SQUARE, VERTICAL */
.infeedl--appearance--square,
.infeedl--appearance--vertical {
  max-width: 400px;
}

.infeedl--appearance--square .infeedl--title,
.infeedl--appearance--vertical .infeedl--title {
  margin-bottom: 15px;
}

.infeedl--appearance--square .infeedl--link-image,
.infeedl--appearance--vertical .infeedl--link-image {
  margin-bottom: 15px;
}

/* OVERLAY */
.infeedl--no-scroll {
  overflow: hidden !important;
}

@media (max-width: 600px) {
  .infeedl--no-scroll {
    position: fixed;
  }
}

.infeedl--embedded-wrapper, .infeedl--embedded--loader {
  position: absolute;
  position: fixed;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 2147483644;
  overflow: auto;
  -webkit-overflow-scrolling:touch;
}

.infeedl--embedded {
  display: block;
  width: 100%;
  height: 100%;
}

.infeedl--embedded-close {
  position: absolute;
  top: 0; /* is set when embedded */
  right: 20px;
  width: 42px;
  height: 42px;
  z-index: 2147483645;
  background: url(//cdn.infeedl.com/shared/creatives/btn-close.png) no-repeat center center;
  background-size: 42px 42px;
  cursor: pointer;
}

@media (max-width: 600px) {
  .infeedl--embedded-close {
    position: fixed;
  }
}

.infeedl--embedded--loader {
  background: rgba(0, 0, 0, .8) url(//cdn.infeedl.com/shared/creatives/loader.svg) no-repeat center center;
  z-index: 2147483645;
}
  """

  constructor: (@id, node) ->
    @node = Infeedl.$(node)
    @node.attr("id", "infeedl-placement-#{@id}")

    @creative = null
    @placement = null
    @viewed = false

    @_client = new Infeedl.Client

  fetch: ->
    return if @node.hasClass("infeedl--loaded")
    @_css("infeedl-base-stylesheet", @constructor._css)

    params = { placement_id: @id }
    params = Infeedl.$.extend(params, sample: @_sample()) if @_sample()

    @_client.get("/creative", params).done(((data) ->
      @placement = data.linked.placements
      @creative = new Infeedl.Creative(data.creatives.format, data.creatives, @placement)
      @_render()
    ).bind(this)).fail(((error) ->
      # console?.error("[INFEEDL] API request failed: ", JSON.stringify(error))
      @placement = error.responseJSON?.linked.placements
      @_fail()
    ).bind(this))

  _sample: ->
    return false if location.hash.indexOf("#infeedl_sample") == -1
    return true if location.hash == "#infeedl_sample"
    location.hash.replace("#infeedl_sample=", "")

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
    @_css("infeedl-placement-#{@id}-stylesheet", @placement.stylesheet)
    @node.html(@creative.render(@placement))
    @node.addClass("infeedl--visible")
    @node.addClass("infeedl--loaded")
    @_bind()

  _fail: ->
    if @placement
      @_css("infeedl-placement-#{@id}-stylesheet", @placement.stylesheet)

    @node.addClass("infeedl--hidden")
    @node.addClass("infeedl--loaded")

  _bind: ->
    # Set up polling for visibility
    @interval = setInterval(@_visible.bind(this), 1000)

    # Clicking on node
    @node.on("click", ((evt) ->
      Infeedl.SharedYandex.event("click", @creative.creative, @placement)
      @_event("click")
      @creative.click()

      evt.preventDefault()
      false
    ).bind(this))

  _visible: ->
    if !@viewed && @node.is(":in-viewport")
      clearInterval(@interval) if @interval
      @viewed = true
      Infeedl.SharedYandex.event("view", @creative.creative, @placement)
      @_event("view")

  _event: (type) ->
    event = { type: type, links: { placement: @id, creative: @creative.creative.id } }
    @_client.post("/events", events: event).done(((data) ->
      # Cool
    ).bind(this)).fail(((error) ->
      # console?.error("[INFEEDL] API request failed: ", JSON.stringify(error))
    ).bind(this))
