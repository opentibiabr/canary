<?php
global $config;
/**
 * Automatic PagSeguro payment system gateway.
 *
 * @name      myaac-pagseguro
 * @author    Ivens Pontes <ivenscardoso@hotmail.com>
 * @author    Slawkens <slawkens@gmail.com>
 * @author    Elson <elsongabriel@hotmail.com>
 * @author    OpenTibiaBR
 * @copyright 2024 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 * @version   2.0
 */
defined('MYAAC') or die('Direct access not allowed!');
$title = 'Donate with Pagseguro';

if (!$code = $_POST['code'] ?? null) {
    echo 'Please select item.';
    return;
}
if (!isset($_POST['reference'])) {
    echo 'Please enter reference.';
    return;
}

require_once(PLUGINS . 'pagseguro/config.php');
require_once(LIBS . 'PagSeguroLibrary/PagSeguroLibrary.php');

$paymentRequest = new PagSeguroPaymentRequest();
$donateSelected = $config['pagSeguro']['donates'][$code];
$value = $donateSelected['value'];
$qtd = $donateSelected['coins'];
$double = $config['pagSeguro']['doubleCoins'] && $qtd >= (int)$config['pagSeguro']['doubleCoinsStart'];
$desc = ($double ? $qtd * 2 : $qtd) . " {$config['pagSeguro']['productName']}" . ($double ? "\r\n DOUBLE COINS" : '');
$paymentRequest->addItem($code, $desc, $qtd, $config['pagSeguro']['value']);
$paymentRequest->setCurrency("BRL");
$paymentRequest->setReference($_POST['reference']);
$paymentRequest->setRedirectUrl(BASE_URL . $config['pagSeguro']['urlRedirect']);
$paymentRequest->addParameter('notificationURL', "https://YOUR_SITE/payments/donate.php");

try {
    $credentials = PagSeguroConfig::getAccountCredentials();
    $checkoutUrl = $paymentRequest->register($credentials);
    header('Location:' . $checkoutUrl);
} catch (PagSeguroServiceException $e) {
    die($e->getMessage());
}
