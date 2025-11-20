<?php

$result = 0;
if ($db->hasColumn('accounts', 'coins')) {
    $column = USE_ACCOUNT_NAME ? 'name' : 'id';
    $result = $db->query("SELECT `coins`, `{$column}` as `{$column}` FROM `accounts` ORDER BY `coins` DESC LIMIT 10;");
}

$twig->display('coins.html.twig', array(
    'result' => $result
));
