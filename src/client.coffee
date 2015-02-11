@Infeedl ||= {}

class @Infeedl.Client
  @_base: "//api.infeedl.com"

  get: (path, params) ->
    Infeedl.$.ajaxq(path, {
      url: "#{@constructor._base}#{path}"
      data: params
      dataType: "json"
      xhrFields:
        withCredentials: true
      crossDomain: true
    })

  post: (path, params) ->
    Infeedl.$.ajax(
      type: "POST"
      url: "#{@constructor._base}#{path}"
      data: params
      dataType: "json"
      xhrFields:
        withCredentials: true
      crossDomain: true
    )
