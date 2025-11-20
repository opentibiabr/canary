<?php
defined('MYAAC') or die('Direct access not allowed!');

require SYSTEM . 'libs/pot/OTS.php';
$ots = POT::getInstance();
require SYSTEM . 'database.php';

if(!isset($db)) {
	$database_error = $locale['step_database_error_mysql_connect'] . '<br/>' .
			$locale['step_database_error_mysql_connect_2'] .
			'<ul>' .
				'<li>' . $locale['step_database_error_mysql_connect_3'] . '</li>' .
				'<li>' . $locale['step_database_error_mysql_connect_4'] . '</li>' .
			'</ul>' . '<br/>' . $error;
}else {
	if($db->hasTable('accounts'))
		define('USE_ACCOUNT_NAME', $db->hasColumn('accounts', 'name'));
}

if(!defined('USE_ACCOUNT_NAME')) {
	define('USE_ACCOUNT_NAME', false);
}
?>