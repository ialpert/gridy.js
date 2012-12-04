/*jslint white: true, browser: true */

(function() {
  "use strict";
  var components, data, i;

  components = {};
  data = [];

  for (i = 1; i < 17; i += 1) {
    data.push({id: i});
  }

  function active(sel) {
    var current, next;

    current = document.querySelector('.active');
    next = document.querySelector(sel);

    if (current) {
      current.classList.remove('active');
    }
    if (next) {
      next.classList.add('active');
    }
  }

  components.category = new Gridy("#category", {
                                    rows      : 1,
                                    cols      : 6,
                                    transSpeed: 500,
                                    index     : 0,
                                    controls  : false,
                                    data      : [
                                      {
                                        name: 'html5',
                                        url : '#html5'
                                      },
                                      {
                                        name: 'home',
                                        url : '#home'
                                      },
                                      {
                                        name: 'video',
                                        url : '#video'
                                      },
                                      {
                                        name: 'music',
                                        url : '#music'
                                      },
                                      {
                                        name: 'github',
                                        url : 'https://github.com/ialpert/gridy.js'
                                      },
                                      {
                                        name: 'download',
                                        url : 'https://github.com/ialpert/gridy.js/zipball/master'
                                      }

                                    ],
                                    onExit    : function(direction) {
                                      if (direction === 'down') {
                                        active('#videos');
                                      }
                                    }
                                  }
  );

  components.featured = new Gridy('#featured', {
    rows       : 2,
    cols       : 2,
    orientation: 'vertical',
    data       : data,
    controls   : false,
    onExit     : function(direction) {
      if (direction === 'right') {
        active('#videos');
      }
      if (direction === 'up') {
        active('#category');
      }
    }
  });

  components.videos = new Gridy('#videos', {
    rows       : 2,
    cols       : 5,
    controls   : false,
    orientation: 'horizontal',
    data       : data,
    onExit     : function(direction) {
      if (direction === 'up') {
        active('#category');
      }
      if (direction === 'left') {
        active('#featured');
      }
    }
  });

  document.addEventListener('keyup', function(e) {
    var id, action = {37: 'left', 38: 'up', 39: 'right', 40: 'down'};

    id = document.querySelector('.active').id;
    action = action[e.keyCode];

    if (action) {
      components[id].move(action);
    }
  });

  active('#videos');

}());