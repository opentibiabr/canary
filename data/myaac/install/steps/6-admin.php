<?php
defined('MYAAC') or die('Direct access not allowed!');

require BASE . 'install/includes/config.php';
if(!$error) {
	require BASE . 'install/includes/database.php';

	if(isset($database_error)) { // we failed connect to the database
		error($database_error);
	}

	$account = 'account';
	if(!USE_ACCOUNT_NAME) {
		$account = 'account_id';
	}

	$twig->display('install.admin.html.twig', array(
		'locale' => $locale,
		'session' => $_SESSION,
		'account' => $account,
		'errors' => isset($errors) ? $errors : null,
		'buttons' => next_buttons(true, $error ? false : true)
	));
}
