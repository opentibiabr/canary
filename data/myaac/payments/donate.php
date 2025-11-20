<?php
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
  !count($config['pagSeguro']['donates'])
) {
  echo "PagSeguro is disabled. If you're an admin please configure this script in config.local.php.";
  return;
}

header('access-control-allow-origin: https://pagseguro.uol.com.br');

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
          "SELECT * FROM `pagseguro_transactions` WHERE `transaction_code` = {$db->quote(
            $transaction_code
          )} AND `account_id` = {$account_id}"
        )
        ->fetch();
      if (
        !($donateSelected =
          $config['pagSeguro']['donates'][$transaction->getItems()[0]->getId()] ?? null)
      ) {
        return false;
      }

      if (!($id = $transactionDB['id'] ?? null)) {
        $createdAt = date('Y-m-d H:i:s');
        $bought = (int) $donateSelected['coins'];
        $extra = (int) $donateSelected['extra'];
        $is_doubled =
          (int) ($config['pagSeguro']['doubleCoins'] &&
            $bought >= (int) $config['pagSeguro']['doubleCoinsStart']);
        $coins_amount = ($is_doubled === 1 ? $bought * 2 : $bought) + $extra;
        $values = "{$db->quote($transaction_code)}, {$account_id}, {$db->quote(
          $payment_method
        )}, {$db->quote($payment_status)}, {$db->quote(
          $donateSelected['id']
        )}, {$coins_amount}, {$bought}, {$is_doubled}, {$db->quote($request)}, {$db->quote(
          $createdAt
        )}";
        $db->exec(
          "INSERT INTO `pagseguro_transactions` (`transaction_code`, `account_id`, `payment_method`, `payment_status`, `code`, `coins_amount`, `bought`, `in_double`, `request`, `created_at`) VALUES ({$values})"
        );
        $transactionDB = $db
          ->query("SELECT * FROM `pagseguro_transactions` WHERE `id` = {$db->lastInsertId()}")
          ->fetch();
        $id = $transactionDB['id'];
      }

      $request = $transactionDB['request'] . $request . PHP_EOL;
      $bought = (int) $transactionDB['bought'];
      $updateAt = date('Y-m-d H:i:s');

      if (
        $transactionDB['delivered'] == '0' &&
        (($payment_method == 'CREDIT_CARD' && $payment_status == 'PAID') ||
          ($payment_method == 'PIX' && $payment_status == 'AVAILABLE'))
      ) {
        $coins_amount = $transactionDB['coins_amount'];

        if ($account_id) {
          $field = strtolower($config['pagSeguro']['donationType']) ?? 'coins_transferable';
          $db->exec(
            "UPDATE `accounts` SET {$field} = {$field} + {$coins_amount} WHERE `id` = {$account_id}"
          );
          $db->exec(
            "UPDATE `pagseguro_transactions` SET `delivered` = 1, `request` = {$db->quote(
              $request
            )}, `updated_at` = {$db->quote($updateAt)} WHERE `id` = {$id}"
          );

          // if you want to activate win items when buy above amount coins
          /*if ($bought >= 16500) {
                        $itemId    = xxxxx; // put item id
                        $count     = $bought < 35000 ? 1 : 3;
                        $status    = 1; //approved
                        $createdAt = date('Y-m-d H:i:s');
                        $valuesIt  = "{$db->quote($transaction_code)}, {$db->quote($itemId)}, {$db->quote('ITEM NAME')}, {$count}, {$account_id}, {$db->quote($payment_method)}, {$db->quote($payment_status)}, {$db->quote($status)}, {$db->quote($request)}, {$db->quote($createdAt)}";
                        $db->exec("INSERT INTO `myaac_send_items` (`transaction_code`, `item_id`, `item_name`, `coins_amount`, `account_id`, `payment_method`, `payment_status`, `status`, `request`, `created_at`) VALUES ({$valuesIt})");
                    }*/

          $values = "{$account_id}, 1, {$coins_amount}, {$db->quote('Donate')}, {$db->quote(
            $updateAt
          )}, 3";
          $db->exec(
            "INSERT INTO `coins_transactions` (`account_id`, `type`, `amount`, `description`, `timestamp`, `coin_type`) VALUES ({$values})"
          );

          $timestamp = strtotime($updateAt);
          $values2 = "{$account_id}, 0, {$db->quote(
            'Donate'
          )}, 3, {$coins_amount}, {$timestamp}, 0, 0";
          $db->exec(
            "INSERT INTO `store_history` (`account_id`, `mode`, `description`, `coin_type`, `coin_amount`, `time`, `timestamp`, `coins`) VALUES ({$values2})"
          );
        }
      } else {
        $db->exec(
          "UPDATE `pagseguro_transactions` SET `request` = {$db->quote(
            $request
          )}, `updated_at` = {$db->quote($updateAt)} WHERE `id` = {$id}"
        );
        if ($transactionDB['delivered'] == '1' && $payment_status == 'CANCELLED') {
          if ($account_id) {
            $now = time();
            $banAt = $now + 86400 * 30;
            $values = "({$account_id}, 3, 22, {$now}, {$banAt}, {$account_id})";
            $db->exec(
              "INSERT INTO `account_bans` (`account_id`, `type`, `reason`, `banned_at`, `expired_at`, `banned_by`) VALUES {$values};"
            );
          }
        }
      }
    } catch (PagSeguroServiceException | \Exception $e) {
      log_append('pagseguro_donate_errors.log', date('Y-m-d H:i:s') . ': ' . $e->getMessage());
      die($e->getMessage());
    }
  }
}
