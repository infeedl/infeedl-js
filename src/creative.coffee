@Infeedl ||= {}

class @Infeedl.Creative
  constructor: (@creative, @placement) ->

  render: ->
    # Override

  _interpolations: ->
    creative: @creative
    placement: @placement
