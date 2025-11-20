<?php
defined('MYAAC') or die('Direct access not allowed!');

if(!isset($_SESSION['var_server_path'])) {
	error($locale['step_database_error_config']);
	$error = true;
}

$config['server_path'] = $_SESSION['var_server_path'];
// take care of trailing slash at the end
if($config['server_path'][strlen($config['server_path']) - 1] != '/')
	$config['server_path'] .= '/';

if((!isset($error) || !$error) && !file_exists($config['server_path'] . 'config.lua')) {
	error($locale['step_database_error_config']);
	$error = true;
}

if(!isset($error) || !$error) {
	$config['lua'] = load_config_lua($config['server_path'] . 'config.lua');
	if(isset($config['lua']['sqlType'])) // tfs 0.3
		$config['database_type'] = $config['lua']['sqlType'];
	else if(isset($config['lua']['mysqlHost'])) // tfs 0.2/1.0
		$config['database_type'] = 'mysql';
	else if(isset($config['lua']['database_type'])) // otserv
		$config['database_type'] = $config['lua']['database_type'];
	else if(isset($config['lua']['sql_type'])) // otserv
		$config['database_type'] = $config['lua']['sql_type'];

	$config['database_type'] = strtolower($config['database_type']);
	if(empty($config['database_type'])) {
		error($locale['step_database_error_database_empty']);
		$error = true;
	}
	else if($config['database_type'] != 'mysql') {
		$locale['step_database_error_only_mysql'] = str_replace('$DATABASE_TYPE$', '<b>' . $config['database_type'] . '</b>', $locale['step_database_error_only_mysql']);
		error($locale['step_database_error_only_mysql']);
		$error = true;
	}
}
?>