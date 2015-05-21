(function(){
  var my_stream;

  navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia;
  navigator.getUserMedia({audio: true, video: true}, function(stream){
    my_stream = stream;
    $('#video').prop('src', URL.createObjectURL(stream));
  }, function(){});
})();
