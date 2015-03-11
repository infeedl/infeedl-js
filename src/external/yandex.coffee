@Infeedl ||= {}

class @Infeedl.Yandex
  constructor: ->
    @metrika = new Ya.Metrika(id: 28959550)

  event: (event, creative, placement) ->
    @metrika.hit(
      creative.content.location,
      creative.title,
      location.href,
      @_params(event, creative, placement),
    )

  _params: (event, creative, placement) ->
    {
      event: event
      creative_id: creative.id
      placement_id: placement.id
    }
