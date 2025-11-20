<?php

$players = 0;
if ($db->hasColumn('players', 'lastlogin')) {
    $players = $db->query("SELECT `id`, `name`, `level`, `lastlogin` FROM players WHERE `id` > 5 ORDER BY lastlogin DESC LIMIT 10;");
}

$twig->display('lastlogin.html.twig', array(
    'players' => $players,
));
