@Infeedl ||= {}
@Infeedl.Creatives ||= {}

class @Infeedl.Creatives.Video extends @Infeedl.Creative
  render: ->
    InfeedlTemplates.video.render(@_interpolations())
