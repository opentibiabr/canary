<?php
require '../common.php';
require SYSTEM . 'init.php';
require SYSTEM . 'functions.php';
require SYSTEM . 'status.php';
require SYSTEM . 'login.php';

if (!admin()) {
  die('Access denied.');
}

if (!$status['online']) {
  die('Offline');
}
?>
<b>Server</b>: <?php echo $status['server'] . ' ' . $status['serverVersion']; ?><br/>
<b>Version</b>: <?php echo $status['clientVersion']; ?><br/><br/>

<b>Monsters</b>: <?php echo $status['monsters']; ?><br/>
<b>Map</b>: <?php echo $status['mapName']; ?>, <b>author</b>: <?php echo $status[
  'mapAuthor'
]; ?>, <b>size</b>: <?php echo $status['mapWidth'] . ' x ' . $status['mapHeight']; ?><br/>
<b>MOTD</b>: <?php echo $status['motd']; ?><br/><br/>

<b>Last check</b>: <?php echo date('H:i:s', $status['lastCheck']); ?>
