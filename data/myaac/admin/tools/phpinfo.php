<?php
define('MYAAC_ADMIN', true);

require '../../common.php';
require SYSTEM . 'functions.php';
require SYSTEM . 'init.php';
require SYSTEM . 'login.php';

if (!admin())
    die('Access denied.');

if (!function_exists('phpinfo'))
    die('phpinfo() disabled on this web server.');

phpinfo();
?>
