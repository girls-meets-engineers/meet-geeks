$(document).ready(function(){
      //Handles menu drop down
      $('.dropdown-menu').find('p').click(function (e) {
          e.stopPropagation();
      });
  });