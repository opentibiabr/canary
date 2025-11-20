<?php
define('MYAAC_ADMIN', true);

require '../../common.php';
require SYSTEM . 'init.php';
require SYSTEM . 'functions.php';
require SYSTEM . 'status.php';
require SYSTEM . 'login.php';

if (!admin())
    die('Access denied.');

if (!$status['online'])
    die('Offline');
?>
<b>Server</b>: <?= $status['server'] . ' ' . $status['serverVersion']; ?><br/>
<b>Version</b>: <?= $status['clientVersion']; ?><br/><br/>
<b>Monsters</b>: <?= $status['monsters']; ?><br/>
<b>Map</b>: <?= $status['mapName']; ?>, <b>author</b>: <?= $status['mapAuthor']; ?>,
<b>size</b>: <?= $status['mapWidth'] . ' x ' . $status['mapHeight']; ?><br/>
<b>MOTD</b>: <?= $status['motd']; ?><br/><br/>
<b>Last check</b>: <?= date("H:i:s", $status['lastCheck']); ?>
