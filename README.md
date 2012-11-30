Gridy.js
========
Gridy.js is a library that can be used in SmartTV's apps. You can use it for carousels, grids, and sliders

Todo:
========
* jQuery plugin
* Tests
* Better TV related example
* Better description


```html
<script src="gridy.min.js"></script>
```

Markup example:

```html
<div id="category">
    <script type="text/tpl">
        <li>{name}</li>
    </script>
    <div class="wrapper">
        <div class="content"></div>
    </div>
</div>
```

JS example:
```javascript
new Gridy("#category", {
                                    rows      : 1,
                                    cols      : 1,
                                    transSpeed: 500,
                                    index     : 4,
                                    data      : data,
                                    onExit    : function(direction) {}
                                  }                               
```

Default values:

```javascript
  default_confing = {
    rows: 1,
    cols: 1,
    transSpeed: 500,
    index: 0,
    data: [],
    controls: true,
    focusedClass: 'focused',
    orientation: 'horizontal',
    onChange: function(elem) {},
    onExit: function(direction) {},
    selectors: {
      container: 'ul',
      wrapper: '.wrapper',
      content: '.content',
      focused: '.focused',
      elem: 'li',
      page: '.page',
      tpl: 'script[type="text/tpl"]'
    }
  };
```
