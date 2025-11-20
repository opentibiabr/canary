<?php
global $db, $twig;
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

$result = [];
if ($db->hasTable('pagseguro_transactions')) {
    $query = $db->query("SELECT `account_id`, SUM(`code`) as total, payment_status FROM `pagseguro_transactions` WHERE `payment_status` = 'AVAILABLE' GROUP BY account_id ORDER BY total DESC LIMIT 10;")->fetchAll();
    foreach ($query as $item) {
        if ($acc = $db->query("SELECT `id`, `name`, `email` FROM `accounts` WHERE `id` = {$item['account_id']}")->fetch()) {
            $result[$acc['id']] = [
                'name'    => $acc['name'],
                'email'   => $acc['email'],
                'players' => getPlayerByAccountId($acc['id']),
                'value'   => "R$ " . number_format((float)$item['total'], 2, ',', '.')
            ];
        }
    }
}
$twig->display('most_donates.html.twig', ['result' => $result]);
