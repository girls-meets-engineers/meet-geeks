  $('.media-list').children().click(function(){
    $(this).siblings().removeClass("active-chat");
    $(this).addClass("active-chat");
  });
