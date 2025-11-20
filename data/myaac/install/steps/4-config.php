<?php
global $config, $locale, $twig;
defined('MYAAC') or die('Direct access not allowed!');

$clients = array();
foreach ($config['clients'] as $client) {
    $client_version = (string)($client / 100);
    if (!strpos($client_version, '.'))
        $client_version .= '.0';
    elseif (strlen($client_version) == 4 && $client >= 1300)
        $client_version .= '0';

    $clients[$client] = $client_version;
}

$twig->display('install.config.html.twig', array(
    'clients' => $clients,
    'timezones' => DateTimeZone::listIdentifiers(),
    'locale' => $locale,
    'session' => $_SESSION,
    'errors' => $errors ?? null,
    'buttons' => next_buttons()
));
