$(function () {
  $('#character_name').blur(function () {
    checkName();
  });
});

var eventId = 0;
var lastSend = 0;

function checkName() {
  if (eventId != 0) {
    clearInterval(eventId);
    eventId = 0;
  }

  if (document.getElementById('character_name').value == '') {
    $('#character_error').html(
      '<span style="color: red">Please enter new character name.</span>',
    );
    var $characterIndicator = $('#character_indicator');
    $characterIndicator.attr('src', 'images/global/general/nok.gif');
    $characterIndicator.show();
    return;
  }

  //anti flood
  var date = new Date();
  var timeNow = parseInt(date.getTime());

  if (lastSend != 0) {
    if (timeNow - lastSend < 1100) {
      eventId = setInterval('checkName()', 1100);
      return;
    }
  }

  var name = document.getElementById('character_name').value;
  $.getJSON(
    'tools/validate.php',
    { name: name, uid: Math.random() },
    function (data) {
      var $characterIndicator = $('#character_indicator');
      if (data.hasOwnProperty('success')) {
        $('#character_error').html(
          '<span style="color: green">' + data.success + '</span>',
        );
        $characterIndicator.attr('src', 'images/global/general/ok.gif');
      } else if (data.hasOwnProperty('error')) {
        $('#character_error').html(
          '<span style="color: red">' + data.error + '</span>',
        );
        $characterIndicator.attr('src', 'images/global/general/nok.gif');
      }

      $characterIndicator.show();
      lastSend = timeNow;
    },
  );
}
