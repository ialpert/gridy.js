(function() {
  var data, components = {};

  data = [
    {name: 1},
    {name: 2},
    {name: 3},
    {name: 4},
    {name: 5},
    {name: 6},
    {name: 7},
    {name: 8},
    {name: 9},
    {name: 10},
    {name: 11},
    {name: 12}
  ];

  components.category = new Gridy("#category", {
                                    rows      : 1,
                                    cols      : 1,
                                    transSpeed: 500,
                                    index     : 4,
                                    data      : data,
                                    onExit    : function(direction) {
                                      if (direction === 'down') {
                                        active('#videos');
                                      }
                                    }
                                  }
  );

  components.category2 = new Gridy("#category2", {
                                     rows       : 6,
                                     cols       : 1,
                                     transSpeed : 300,
                                     index      : 2,
                                     data       : data,
                                     orientation: 'vertical',
                                     onExit     : function(direction) {
                                       if (direction === 'right') {
                                         active('#videos');
                                       }
                                     }
                                   }
  );

  components.featured = new Gridy("#featured", {
                                    rows  : 1,
                                    cols  : 4,
                                    data  : data,
                                    onExit: function(direction) {
                                      if (direction === 'up') {
                                        active('#videos');
                                      }
                                    }
                                  }
  );

  components.videos = new Gridy("#videos", {
                                  rows       : 3,
                                  cols       : 3,
                                  orientation: 'vertical',
                                  onExit     : function(direction) {
                                    if (direction === 'left') {
                                      active('#category2');
                                    }
                                    if (direction === 'up') {
                                      active('#category');
                                    }
                                    if (direction === 'down') {
                                      active('#featured');
                                    }
                                  }
                                }
  ).insert(data);

  function active(sel) {
    $('.active').removeClass('active');
    $(sel).addClass('active');
  }

  $(document).on('keyup', function(e) {
    var id, action = {37: 'left', 38: 'up', 39: 'right', 40: 'down'};

    id = $('.active').attr('id');
    action = action[e.keyCode];

    if (action) {
      components[id].move(action);
    }
  });

  active('#category');

})();