<?php

if(!isset($database_migration_20)) {
	databaseMigration20();
}

function databaseMigration20(&$content = '') {
	global $db;

	$config_file = BASE . 'config.local.php';
	if(!is_writable($config_file)) { // we can't do anything, just ignore
		return false;
	}

	$content_of_file = trim(file_get_contents($config_file));
	if(strpos($content_of_file, 'highscores_ids_hidden') !== false) { // already present
		return true;
	}

	$query = $db->query("SELECT `id` FROM `players` WHERE (`name` = " . $db->quote("Rook Sample") . " OR `name` = " . $db->quote("Sorcerer Sample") . " OR `name` = " . $db->quote("Druid Sample") . " OR `name` = " . $db->quote("Paladin Sample") . " OR `name` = " . $db->quote("Knight Sample") . " OR `name` = " . $db->quote("Account Manager") . ") ORDER BY `id`;");

	$highscores_ignored_ids = array();
	if($query->rowCount() > 0) {
		foreach($query->fetchAll() as $result)
			$highscores_ignored_ids[] = $result['id'];
	}
	else {
		$highscores_ignored_ids[] = 0;
	}

	$php_on_end = substr($content_of_file, -2, 2) == '?>';
	$content = PHP_EOL;
	if($php_on_end) {
		$content .= '<?php';
	}

	$content .= PHP_EOL;
	$content .= '$config[\'highscores_ids_hidden\'] = array(' . implode(', ', $highscores_ignored_ids) . ');';
	$content .= PHP_EOL;

	if($php_on_end) {
		$content .= '?>';
	}

	file_put_contents($config_file, $content, FILE_APPEND);
	return true;
}
?>