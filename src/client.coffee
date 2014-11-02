@Infeedl ||= {}

class @Infeedl.Client
  @_base: "https://api.infeedl.com"

  get: (path, params) ->
    Zepto.ajax(
      url: "#{@constructor._base}#{path}"
      data: params
      dataType: "json"
    )

  post: (path, params) ->
    Zepto.ajax(
      type: "POST"
      url: "#{@constructor._base}#{path}"
      data: params
      dataType: "json"
    )
