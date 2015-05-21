$(function() {
      var wH = $(window).height();
      $(function(){
          $('#hero').css('height', wH + 130 +'px');
          $('.signup-well').css('top', wH / 2 - 10 + 'px');
      });
});