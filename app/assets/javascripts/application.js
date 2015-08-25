// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
//= require bootstrap.min

$('form.create_playlist').submit(function(e){
  if (!$('input.form-control').val()) {
    alert("Enter a name for your playlist!");
    return false;
  }

  $('.progress-bar').css('width', '2%');
  $('.progress').show();

  var $form = $(this);
  var count = 0;
  var playlist_id = -1;

  $.ajax({
    url: '/playlists?' + $form.serialize(),
    method: 'POST',
    complete: function(response) {
      var json = response.responseJSON;
      if (json.status == 200) {
        getProgress(json.playlist_id);
      } else {
        location.reload();
      }
    }
  });

  return false;
});

var $progressBar = $('.progress-bar');

function getProgress(playlist_id) {
  var timerId = setInterval(function() {
    $.ajax({
      url: '/playlists/' + playlist_id,
      method: 'PUT',
      complete: function(response) {
        var json = response.responseJSON;
        if (json.status == 400) {
          console.log("increasing width to " + json.percent);
          $progressBar.css('width', json.percent)
        } else if (json.status == 200) {
          console.log("at 100%");
          $progressBar.css('width', '100%');
          clearInterval(timerId);
          $('.progress').hide();
          showAlert(json.alert);
        }
      }
    });
  }, 3000);
};

function showAlert(text) {
  $('.alerts_text').empty().append(text);
  $('.alert').show();
};
