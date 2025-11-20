<?php

$result = 0;
if ($db->hasColumn('accounts', 'coins_transferable')) {
    $column = USE_ACCOUNT_NAME ? 'name' : 'id';
    $result = $db->query("SELECT `coins_transferable`, `{$column}` as `{$column}` FROM `accounts` ORDER BY `coins_transferable` DESC LIMIT 10;");
}

$twig->display('coinstransferable.html.twig', array(
    'result' => $result
));
