(function(){
  $(document).ready(function(){
    $(document).on('click', '#edit-apply', function(){
      var name = $('#inputName').val();
      var description = $('#inputDescription').val();
      var money = $('#inputMoney').val();
      var age = $('#inputAge').val();
      var id = $('#inputId').val();
      $.ajax({
        type: "PUT",
        url: "/profiles/" + id,
        data: { 'json': '{"name": "' + name + '", "description": "' + description + '", "money": ' + money + ', "age": ' + age + '}' },
      }).done(function(response) {
        if(response['id']) {
          location.href = "/profiles/show/" + response['id'];
        }else {
          alert(response);
        }
      });
    });
  });
})();
