$(window).load(function() {
  var $grid = $('#grid'),
      $sizer = $grid.find('.shuffle__sizer');

  $grid.shuffle({
    itemSelector: '.picture-item',
    sizer: $sizer
  });

  // Sorting options
  $('.sort-options').on('change', function() {
    var sort = this.value,
        opts = {};

    // We're given the element wrapped in jQuery
    // TODO: diet
    if(sort === 'age') {
      opts = {
        by: function($el) {
          return $el.data('age');
        }
      };
    } else if(sort === 'money') {
      opts = {
        reverse: true,
        by: function($el) {
          return $el.data('money');
        }
      };
    } else if(sort === 'name') {
      opts = {
        by: function($el) {
          return $el.data('name').toLowerCase();
        }
      };
    }

    // Filter elements
    // TODO diet
    $grid.shuffle('sort', opts);
  });

  /* 
  $('.fillter-list li').on('click', function() {
    var $this = $(this),
    group_age = $this.data('age');
    group_money = $this.data('money');

    $('.fillter-list .active').removeClass('active');
    $this.addClass('active');
  
    if(group_age != 'all'){
      $grid.shuffle('shuffle', function($el, shuffle) {
        var digit_age = Math.floor($el.data('ages') / 10)*10;
        console.log(digit_age == group_age);
        return digit_age == group_age;
      });
    } else {
        $grid.shuffle('shuffle', 'all');
    }

    if(group_money != 'all'){
      $grid.shuffle('shuffle', function($el, shuffle) {
        var money = $el.data('moneys')[0];
        return money >= group_money; 
      });
    } else {
      $grid.shuffle('shuffle', 'all');
    }
  });
  */

  $('.fillter-list-age li').on('click', function() {
    var $this = $(this),
    group = $this.data('age');

    $('.fillter-list-age .active').removeClass('active');
    $this.addClass('active');
  
    if(group != 'all'){
      $grid.shuffle('shuffle', function($el, shuffle) {
        var digit_group = Math.floor($el.data('ages') / 10)*10;
        return digit_group == group;
      });
    } else {
        $grid.shuffle('shuffle', 'all');
    }
  });
  $('.fillter-list-money li').on('click', function() {
    var $this = $(this),
    group = $this.data('money');

    $('.fillter-list-money .active').removeClass('active');
    $this.addClass('active');
  
    if(group != 'all'){
      $grid.shuffle('shuffle', function($el, shuffle) {
        var num_grps = $el.data('moneys')[0];
        return num_grps >= group; 
      });
    } else {
        $grid.shuffle('shuffle', 'all');
    }
  });

  // Advanced filtering
  $('.shuffle-search').on('keyup change', function() {
    var val = this.value.toLowerCase();
    $grid.shuffle('shuffle', function($el, shuffle) {

      // Only search elements in the current group
      if (shuffle.group !== 'all' && $.inArray(shuffle.group, $el.data('groups')) === -1) {
        return false;
      }

      var text = $.trim( $el.find('.picture-description').text() ).toLowerCase();
      return text.indexOf(val) !== -1;
    });
  });

  $('.request-button').click(function() {
    engineer_id = $(this).attr('id'); 
    $.ajax({
      type: "POST",
      url: "/request_lists",
      data: { 'engineer_id': engineer_id },
    }).fail(function() {
      $('#' + engineer_id  + '.request-button').attr('disabled', true).text("Requested");
    }).done(function() {
      window.location.href = '/chat';
    });
  });
});
