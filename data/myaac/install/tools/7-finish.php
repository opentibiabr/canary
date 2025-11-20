<?php
define('MYAAC_INSTALL', true);

require_once '../../common.php';

require SYSTEM . 'functions.php';
require BASE . 'install/includes/functions.php';
require BASE . 'install/includes/locale.php';

ini_set('max_execution_time', 300);

@ob_end_flush();
ob_implicit_flush();

header('X-Accel-Buffering: no');

if(isset($config['installed']) && $config['installed'] && !isset($_SESSION['saved'])) {
	warning($locale['already_installed']);
	return;
}

require SYSTEM . 'init.php';

$deleted = 'deleted';
if($db->hasColumn('players', 'deletion'))
	$deleted = 'deletion';

$time = time();
function insert_sample_if_not_exist($p) {
	global $db, $success, $deleted, $time;

	$query = $db->query('SELECT `id` FROM `players` WHERE `name` = ' . $db->quote($p['name']));
	if($query->rowCount() == 0) {
		if(!query("INSERT INTO `players` (`id`, `name`, `group_id`, `account_id`, `level`, `vocation`, `health`, `healthmax`, `experience`, `lookbody`, `lookfeet`, `lookhead`, `looklegs`, `looktype`, `maglevel`, `mana`, `manamax`, `manaspent`, `soul`, `town_id`, `posx`, `posy`, `posz`, `conditions`, `cap`, `sex`, `lastlogin`, `lastip`, `save`, `lastlogout`, `balance`, `$deleted`, `created`, `hidden`, `comment`) VALUES (null, " . $db->quote($p['name']) . ", 1, " . getSession('account') . ", " . $p['level'] . ", " . $p['vocation_id'] . ", " . $p['health'] . ", " . $p['healthmax'] . ", " . $p['experience'] . ", 118, 114, 38, 57, " . $p['looktype'] . ", 0, " . $p['mana'] . ", " . $p['manamax'] . ", 0, " . $p['soul'] . ", 1, 1000, 1000, 7, '', " . $p['cap'] . ", 1, " . $time . ", 2130706433, 1, " . $time . ", 0, 0, " . $time . ", 1, '');"))
			$success = false;
	}
}

$success = true;
insert_sample_if_not_exist(array('name' => 'Rook Sample', 'level' => 1, 'vocation_id' => 0, 'health' => 150, 'healthmax' => 150, 'experience' => 0, 'looktype' => 130, 'mana' => 0, 'manamax' => 0, 'soul' => 100, 'cap' => 400));
insert_sample_if_not_exist(array('name' => 'Sorcerer Sample', 'level' => 8, 'vocation_id' => 1, 'health' => 185, 'healthmax' => 185, 'experience' => 4200, 'looktype' => 130, 'mana' => 90, 'manamax' => 90, 'soul' => 100, 'cap' => 470));
insert_sample_if_not_exist(array('name' => 'Druid Sample', 'level' => 8, 'vocation_id' => 2, 'health' => 185, 'healthmax' => 185, 'experience' => 4200, 'looktype' => 130, 'mana' => 90, 'manamax' => 90, 'soul' => 100, 'cap' => 470));
insert_sample_if_not_exist(array('name' => 'Paladin Sample', 'level' => 8, 'vocation_id' => 3, 'health' => 185, 'healthmax' => 185, 'experience' => 4200, 'looktype' => 129, 'mana' => 90, 'manamax' => 90, 'soul' => 100, 'cap' => 470));
insert_sample_if_not_exist(array('name' => 'Knight Sample', 'level' => 8, 'vocation_id' => 4, 'health' => 185, 'healthmax' => 185, 'experience' => 4200, 'looktype' => 131, 'mana' => 90, 'manamax' => 90, 'soul' => 100, 'cap' => 470));

if($success) {
	success($locale['step_database_imported_players']);
}

require LIBS . 'items.php';
if (Items::loadFromXML()) {
    success($locale['step_database_loaded_items']);
} else {
    error(Items::getError());
}

// update config.highscores_ids_hidden
require_once SYSTEM . 'migrations/20.php';
$database_migration_20 = true;
$content = '';
if(!databaseMigration20($content)) {
	$locale['step_database_error_file'] = str_replace('$FILE$', '<b>' . BASE . 'config.local.php</b>', $locale['step_database_error_file']);
	warning($locale['step_database_error_file'] . '<br/>
				<textarea cols="70" rows="10">' . $content . '</textarea>');
}

// add z_polls tables
require_once SYSTEM . 'migrations/22.php';

// add myaac_pages pages
require_once SYSTEM . 'migrations/27.php';
require_once SYSTEM . 'migrations/30.php';

$locale['step_finish_desc'] = str_replace('$ADMIN_PANEL$', generateLink(str_replace('tools/', '',ADMIN_URL), $locale['step_finish_admin_panel'], true), $locale['step_finish_desc']);
$locale['step_finish_desc'] = str_replace('$HOMEPAGE$', generateLink(str_replace('tools/', '', BASE_URL), $locale['step_finish_homepage'], true), $locale['step_finish_desc']);
$locale['step_finish_desc'] = str_replace('$LINK$', generateLink('https://github.com/opentibiabr/myaac/issues', 'OpenTibiaBR Issues', true), $locale['step_finish_desc']);

success($locale['step_finish_desc']);
