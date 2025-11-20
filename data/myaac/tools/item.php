<?php
require '../common.php';
require SYSTEM . 'item.php';

if (isset($_GET['id'])) {
  outputItem($_GET['id'], $_GET['count']);
}
?>
