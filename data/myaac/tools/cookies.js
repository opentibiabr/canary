function getCookie(name) {
  if (document.cookie.length > 0) {
    c_start = document.cookie.indexOf(name + '=');
    if (c_start != -1) {
      c_start = c_start + name.length + 1;
      c_end = document.cookie.indexOf(';', c_start);
      if (c_end == -1) c_end = document.cookie.length;

      return unescape(document.cookie.substring(c_start, c_end));
    }
  }

  return '';
}

function setCookie(name, value, expireDays) {
  var exdate = new Date();
  exdate.setDate(exdate.getDate() + expireDays);
  document.cookie =
    name +
    '=' +
    escape(value) +
    (expireDays == null ? '' : ';expires=' + exdate.toGMTString());
}
