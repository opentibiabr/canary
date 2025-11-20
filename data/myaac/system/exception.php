<?php

require LIBS . 'SensitiveException.php';

/**
 * @param Exception $exception
 */
function exception_handler($exception)
{
  $message = $exception->getMessage();
  if ($exception instanceof SensitiveException) {
    $message =
      'This error is sensitive and has been logged into ' .
      LOGS .
      'error.log.<br/>View this file for more information.';

    // log error to file
    $f = fopen(LOGS . 'error.log', 'ab');
    if (!$f) {
      $message =
        'We wanted to save detailed informations about this error, but file: ' .
        LOGS .
        "error.log couldn't be opened for writing.. so the detailed information couldn't be saved.. are you sure directory system/logs is writable by web server? Correct this, and then refresh this site.";
    } else {
      fwrite($f, '[' . date(DateTime::RFC1123) . '] ' . $exception->getMessage() . PHP_EOL);
      fclose($f);
    }
  }

  $backtrace_formatted = nl2br($exception->getTraceAsString());
  $message = $message . "<br/><br/>File: {$exception->getFile()}<br/>Line: {$exception->getLine()}";

  // display basic error message without template
  // template is missing, why? probably someone deleted templates dir, or it wasn't downloaded right
  $template_file = SYSTEM . 'templates/exception.html.twig';
  if (!file_exists($template_file)) {
    echo 'Something went terribly wrong..<br/><br/>';
    echo "$message<br/><br/>";
    echo 'Backtrace:<br>';
    echo $backtrace_formatted;
    return;
  }

  // display beautiful error message
  // the file is .twig.html, but its not really parsed by Twig
  // we just replace some values manually
  // cause in case Twig throws exception, we can show it too
  $content = file_get_contents($template_file);
  $content = str_replace(
    [
      '{{ BASE_URL }}',
      '{{ exceptionClass }}',
      '{{ message }}',
      '{{ backtrace }}',
      '{{ powered_by }}',
    ],
    [
      BASE_URL,
      get_class($exception),
      $message,
      $backtrace_formatted,
      base64_decode(
        'UG93ZXJlZCBieSA8YSBocmVmPSJodHRwczovL2dpdGh1Yi5jb20vb3BlbnRpYmlhYnIvbXlhYWMiIHRhcmdldD0iX2JsYW5rIj5PcGVuVGliaWFCUjwvYT4gYW5kIENvbnRyaWJ1dG9ycy4='
      ),
    ],
    $content
  );
  echo $content;
}

set_exception_handler('exception_handler');
