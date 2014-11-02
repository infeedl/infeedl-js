@Infeedl ||= {}
@Infeedl.Creatives ||= {}

class @Infeedl.Creatives.Article extends @Infeedl.Creative
  render: ->
    InfeedlTemplates.article.render(@_interpolations())
