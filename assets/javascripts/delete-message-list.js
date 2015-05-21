$('#delete-message-list').click(function() {
    alert($('.active-chat').attr('companion-id'));
    $.ajax({
      type: "DELETE",
      url: "/message-lists/" + $('.active-chat').attr('companion-id'),
    }).fail(function() {
      alert("hogeeee");
    }).done(function() {
      window.location.href = '/chat';
    });
  });