<?php
global $config;
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
$title = 'Buy Box with Pagseguro';

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
$boxSelected = $config['pagSeguro']['boxes'][$code];
$paymentRequest->addItem($code, $boxSelected['name'], 1.00, $boxSelected['value']);
$paymentRequest->setCurrency("BRL");
$paymentRequest->setReference($_POST['reference']);
$paymentRequest->setRedirectUrl(BASE_URL . $config['pagSeguro']['urlRedirect']);
$paymentRequest->addParameter('notificationURL', "https://YOUR_SITE/payments/buybox.php");

try {
    $credentials = PagSeguroConfig::getAccountCredentials();
    $checkoutUrl = $paymentRequest->register($credentials);
    header('Location:' . $checkoutUrl);
} catch (PagSeguroServiceException $e) {
    die($e->getMessage());
}
