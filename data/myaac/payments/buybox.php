<?php
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

//https://dev.pagbank.uol.com.br/v1/docs/api-notificacao-v1

global $db;
require_once '../common.php';
require_once SYSTEM . 'functions.php';
require_once SYSTEM . 'init.php';
require_once PLUGINS . 'pagseguro/config.php';
require_once LIBS . 'PagSeguroLibrary/PagSeguroLibrary.php';

if (
  !isset($config['pagSeguro']) ||
  !count($config['pagSeguro']) ||
  !count($config['pagSeguro']['boxes'])
) {
  echo "PagSeguro is disabled. If you're an admin please configure this script in config.local.php.";
  return;
}

header('access-control-allow-origin: https://pagseguro.uol.com.br');

$table = 'myaac_send_items';
$method = $_SERVER['REQUEST_METHOD'];
if ('post' == strtolower($method)) {
  $type = $_POST['notificationType'];
  $notificationCode = $_POST['notificationCode'];

  if ($type === 'transaction') {
    try {
      $credentials = PagSeguroConfig::getAccountCredentials();
      $transaction = PagSeguroNotificationService::checkTransaction(
        $credentials,
        $notificationCode
      );

      $transaction_code = $transaction->getCode();
      $account_id = (int) $transaction->getReference();
      $payment_method = $transaction->getPaymentMethod()->getType()->getTypeFromValue();
      $payment_status = $transaction->getStatus()->getTypeFromValue();
      $request = json_encode($_POST);

      $transactionDB = $db
        ->query(
          "SELECT * FROM `{$table}` WHERE `transaction_code` = {$db->quote(
            $transaction_code
          )} AND `account_id` = {$account_id}"
        )
        ->fetch();

      if (
        !($boxSelected =
          $config['pagSeguro']['boxes'][$transaction->getItems()[0]->getId()] ?? null)
      ) {
        return false;
      }

      if (!($id = $transactionDB['id'] ?? null)) {
        $createdAt = date('Y-m-d H:i:s');
        $values = "{$db->quote($transaction_code)}, {$db->quote($boxSelected['id'])}, {$db->quote(
          $boxSelected['name']
        )}, 1, {$account_id}, {$db->quote($payment_method)}, {$db->quote(
          $payment_status
        )}, {$db->quote($request)}, {$db->quote($createdAt)}";
        $db->exec(
          "INSERT INTO `{$table}` (`transaction_code`, `item_id`, `item_name`, `item_count`, `account_id`, `payment_method`, `payment_status`, `request`, `created_at`) VALUES ({$values})"
        );
        $transactionDB = $db
          ->query("SELECT * FROM `{$table}` WHERE `id` = {$db->lastInsertId()}")
          ->fetch();
        $id = $transactionDB['id'];
      }

      $request = $transactionDB['request'] . $request . PHP_EOL;
      $updateAt = date('Y-m-d H:i:s');

      if (
        $transactionDB['status'] == '0' &&
        (($payment_method == 'CREDIT_CARD' && $payment_status == 'PAID') ||
          ($payment_method == 'PIX' && $payment_status == 'AVAILABLE'))
      ) {
        $db->exec(
          "UPDATE `{$table}` SET `status` = '1', `request` = {$db->quote(
            $request
          )}, `updated_at` = {$db->quote($updateAt)} WHERE `id` = {$id}"
        );
      } else {
        $db->exec(
          "UPDATE `{$table}` SET `request` = {$db->quote($request)}, `updated_at` = {$db->quote(
            $updateAt
          )} WHERE `id` = {$id}"
        );
        if (
          in_array($transactionDB['status'], ['1', '2']) &&
          $payment_method != 'PIX' &&
          $payment_status == 'CANCELLED'
        ) {
          $now = time();
          $banAt = $now + 86400 * 30;
          $values = "({$account_id}, 3, 22, {$now}, {$banAt}, {$account_id})";
          $db->exec(
            "INSERT INTO `account_bans` (`account_id`, `type`, `reason`, `banned_at`, `expired_at`, `banned_by`) VALUES {$values};"
          );
        }
      }
    } catch (PagSeguroServiceException | \Exception $e) {
      log_append('pagseguro_buybox_errors.log', date('Y-m-d H:i:s') . ': ' . $e->getMessage());
      die($e->getMessage());
    }
  }
}
