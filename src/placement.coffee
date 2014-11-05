@Infeedl ||= {}

class @Infeedl.Placement
  constructor: (node) ->
    @node = Zepto(node)
    @id = @node.attr("data-infeedl-placement")
    @creative = null

    @_client = new Infeedl.Client
    @_retrieve()

  _sample: ->
    location.hash == "#infeedl_sample"

  _retrieve: ->
    params = { placement_id: @id }
    params = Zepto.extend(params, sample: true) if @_sample()

    @_client.get("/creative", params).done(((data) ->
      format = data.creatives.format
      Creative = Infeedl.Creatives["#{format.charAt(0).toUpperCase()}#{format.slice(1)}"]

      @creative = new Creative(data.creatives)
      @_render()
    ).bind(this)).fail(( ->
      @_fail()
    ).bind(this))

  _render: ->
    @node.html(@creative.render())
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
