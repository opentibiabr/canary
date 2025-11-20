<?php
/**
 * Guilds
 *
 * @package   MyAAC
 * @author    Gesior <jerzyskalski@wp.pl>
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');
$title = 'Guilds';

if($db->hasTable('guild_members'))
	define('GUILD_MEMBERS_TABLE', 'guild_members');
else
	define('GUILD_MEMBERS_TABLE', 'guild_membership');

define('MOTD_EXISTS', $db->hasColumn('guilds', 'motd'));

//show list of guilds
if(empty($action)) {
	require PAGES . 'guilds/list_of_guilds.php';
}
else {
	if(!ctype_alnum(str_replace(array('-', '_'), '', $action))) {
		error('Error: Action contains illegal characters.');
	}
	else if(file_exists(PAGES . 'guilds/' . $action . '.php')) {
		require PAGES . 'guilds/' . $action . '.php';
	}
	else {
		error('This page does not exists.');
	}
}
