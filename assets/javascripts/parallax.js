jQuery(function() {
  var top = $('#hero').offset().top; // default
  jQuery(window).scroll(function() {
    var value = $(this).scrollTop(); // how much scroll
    jQuery('#hero').css('top', top + 80 + value / 1.7);
  });
});