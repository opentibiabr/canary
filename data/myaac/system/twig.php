<?php

use Twig\Environment as Twig_Environment;
use Twig\Extension\DebugExtension as Twig_DebugExtension;
use Twig\Loader\FilesystemLoader as Twig_FilesystemLoader;
use Twig\TwigFilter;
use Twig\TwigFunction;

$dev_mode = config('env') === 'dev';
$twig_loader = new Twig_FilesystemLoader(SYSTEM . 'templates');
$twig = new Twig_Environment($twig_loader, [
  'cache' => CACHE . 'twig/',
  'auto_reload' => $dev_mode,
  'debug' => $dev_mode,
]);

$twig_loader->addPath(PLUGINS);

$twig->addGlobal('logged', false);
$twig->addGlobal('account_logged', new OTS_Account());

if ($dev_mode) {
  $twig->addExtension(new Twig_DebugExtension());
}
unset($dev_mode);

$function = new TwigFunction('getStyle', function ($i) {
  return getStyle($i);
});
$twig->addFunction($function);

$function = new TwigFunction('getLink', function ($s) {
  return getLink($s);
});
$twig->addFunction($function);

$function = new TwigFunction('getPlayerLink', function ($s, $p) {
  return getPlayerLink($s, $p);
});
$twig->addFunction($function);

$function = new TwigFunction('getGuildLink', function ($s, $p) {
  return getGuildLink($s, $p);
});
$twig->addFunction($function);

$function = new TwigFunction(
  'hook',
  function ($context, $hook, array $params = []) {
    global $hooks;

    if (is_string($hook)) {
      if (defined($hook)) {
        $hook = constant($hook);
      } else {
        // plugin/template has a hook that this version of myaac does not support
        // just silently return
        return;
      }
    }

    $params['context'] = $context;
    $hooks->trigger($hook, $params);
  },
  ['needs_context' => true]
);
$twig->addFunction($function);

$function = new TwigFunction('config', function ($key) {
  return config($key);
});
$twig->addFunction($function);

$function = new TwigFunction('getCustomPage', function ($name) {
  $success = false;
  return getCustomPage($name, $success);
});
$twig->addFunction($function);

$filter = new TwigFilter('urlencode', function ($s) {
  return urlencode($s);
});

$twig->addFilter($filter);
unset($function, $filter);
