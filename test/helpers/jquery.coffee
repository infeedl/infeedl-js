computedStyle = (elem, prop) ->
  if elem[0].currentStyle
    return elem[0].currentStyle[prop]
  else if window.getComputedStyle
    window.getComputedStyle(elem[0], null).getPropertyValue(prop)
