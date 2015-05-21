(function(){
  $(document).ready(function() {
    $(document).on('click', '#authenticate', function(){
      var val = $('#select-authenticate').val();
      switch(val) {
        case 'geek':
          location.href = '/login/github';
          break;
        case 'woman':
          location.href = '/login/facebook';
          break;
      }
    });
  });
})();
