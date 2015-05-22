# Infeedl JS

[![Build Status](https://travis-ci.org/infeedl/infeedl-js.svg?branch=master)](https://travis-ci.org/infeedl/infeedl-js)

[![Sauce Test Status](https://saucelabs.com/browser-matrix/infeedl.svg)](https://saucelabs.com/u/infeedl)

## Integration

### Simple

Add code of INFEEDL creative block to the specific place on a page:

```html
<div data-infeedl-placement="YOUR PLACEMENT ID"></div>
```

Include INFEEDL library at the end of a page:

```javascript
<script src="//cdn.infeedl.com/js/infeedl.min.js" crossorigin></script>
```

### Advanced

#### Creative instead of content

Add following style to a page:

```css
<style type="text/css">
.infeedl--placement {
  -webkit-transition: opacity 0.3s linear;
  -moz-transition: opacity 0.3s linear;
  -o-transition: opacity 0.3s linear;
  -ms-transition: opacity 0.3s linear;
  transition: opacity 0.3s linear;

  filter: alpha(opacity=0);
  -moz-opacity: 0;
  opacity: 0;
}

.infeedl--loaded {
  filter: alpha(opacity=1);
  -moz-opacity: 1;
  opacity: 1;
}
</style>
```

Add `class` and `data-infeedl-placement` attributes to your content block:

```html
<div class="infeedl--placement" data-infeedl-placement="YOUR PLACEMENT ID">
  Your content is here
</div>
```

Include INFEEDL library at the end of a page:

```javascript
<script src="//cdn.infeedl.com/js/infeedl.min.js" crossorigin></script>
```

This way INFEEDL will replace your content with creative or display
original content in case there is no creative at the moment.

### API

#### Placement

Initialize placement with an id and a node to render in:

```javascript
var node = document.getElementById("infeedl-placement-node-id")
var placement = new Infeedl.Placement("YOUR PLACEMENT ID", node)
```

Fetch the creative, optionally passing the callbacks:

```javascript
placement.fetch({
  onSuccess: function(placement_id) {},
  onFailure: function(placement_id) {}
})
```

#### Iframe

Include INFEEDL library at the end of a page:

```javascript
<script src="//cdn.infeedl.com/js/infeedl.min.js" crossorigin></script>
```

Initialize iframe optionally passing the selector to start height broadcasting:

```javascript
var infeedl = new Infeedl.Iframe("body");
```

Call the action when it has been performed:

```javascript
infeedl.action();
```

## Development

- Install NPM dependencies: `npm install`
- Install grunt-cli: `npm install -g grunt-cli`
- Build: `grunt build`
- Build and test: `grunt test`
