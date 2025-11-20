<?php
global $config, $twig, $logged;
/**
 * Automatic PagSeguro payment system gateway.
 *
 * @name      myaac-pagseguro
 * @author    Elson <elsongabriel@hotmail.com>
 * @author    OpenTibiaBR
 * @copyright 2024 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 * @version   2.0
 */
defined('MYAAC') or die('Direct access not allowed!');

require_once(PLUGINS . 'pagseguro/config.php');
$twig->addGlobal('config', $config);

if (!isset($config['pagSeguro']) || !count($config['pagSeguro']) || !count($config['pagSeguro']['boxes'])) {
    echo "PagSeguro is disabled. If you're an admin please configure this script in config.local.php.";
    return;
}

if (!extension_loaded('curl')) {
    error("cURL php extension is not loaded, please install it with following command (on linux):" . "<br/>" .
        "sudo apt-get install php5-curl" . "<br/>" .
        "sudo service apache2 restart" . "<br/><br/>" .
        "for XAMPP (Windows) you need to uncomment (Remove selicolon - ;) this line in your php.ini:" . "<br/>" .
        ";extension=php_curl.dll");
    return;
}

$is_localhost = strpos(BASE_URL, 'localhost') !== false || strpos(BASE_URL, '127.0.0.1') !== false;
$config['enablePagseguroLocal'] = $config['enablePagseguroLocal'] ?? false;
if ($is_localhost && !$config['enablePagseguroLocal']) {
    warning("PagSeguro is not supported on localhost (" . BASE_URL . "). Please change your domain to public one and visit this site again later.<br/>
	This site is visible, but you can't donate.");
}

if (empty($action)) {
    if (!$logged) {
        $was_before = $config['friendly_urls'];
        $config['friendly_urls'] = true;

        echo 'To buy coins you need to be logged. ' . generateLink(getLink('?subtopic=accountmanagement') . '&redirect=' . urlencode(BASE_URL . '?subtopic=boxes'), 'Login') . ' first to buy a surprise box.';

        $config['friendly_urls'] = $was_before;
    } else {
        echo $twig->render('donate-box.html.twig', ['is_localhost' => $is_localhost]);
    }
} elseif ($action == 'final') {
    echo $twig->render('donate-final.html.twig');
}
