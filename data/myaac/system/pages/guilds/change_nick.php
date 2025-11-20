<?php
/**
 * Change nick
 *
 * @package   MyAAC
 * @author    Gesior <jerzyskalski@wp.pl>
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

if(!$logged) {
	$errors[] = "You are not logged in. You can't change nick.";
	$twig->display('error_box.html.twig', array('errors' => $errors));
	$twig->display('guilds.back_button.html.twig');
	return;
}

$name = isset($_REQUEST['name']) ? stripslashes($_REQUEST['name']) : null;
$new_nick = isset($_REQUEST['nick']) ? stripslashes($_REQUEST['nick']) : null;
$guild_name = isset($_REQUEST['guild']) ? urldecode($_REQUEST['guild']) : null;

if(!$name) {
	$errors[] = 'Please enter new name.';
	return;
}

if(!$new_nick) {
	$errors[] = 'Please enter new nick.';
	return;
}

if(empty($errors))
{
	$guild = new OTS_Guild();
	$guild->find($guild_name);
	if(!$guild->isLoaded())
		$errors[] = 'Guild with name <b>' . $guild_name . "</b> doesn't exist.";
}

if(!empty($errors))
{
	$twig->display('error_box.html.twig', array('errors' => $errors));
	$twig->display('guilds.back_button.html.twig');
	return;
}

$player = new OTS_Player();
$player->find($name);
$player_from_account = false;

if(!Validator::guildNick($new_nick)) {
	$errors[] = Validator::getLastError();
}

if(!$player->isLoaded()) {
	$errors[] = 'Unknow error occured. Player cannot be loaded';
}

$account_players = $account_logged->getPlayersList();
if(!count($account_players)) {
	$errors[] = 'This player is not from your account.';
}

if(empty($errors)) {
	foreach($account_players as $acc_player) {
		if($acc_player->getId() == $player->getId())
			$player_from_account = true;
	}

	if(!$player_from_account) {
		$errors[] = 'This player is not from your account.';
	}

	if(empty($errors))
	{
		$player->setGuildNick($new_nick);
		$twig->display('success.html.twig', array(
			'title' => 'Nick Changed',
			'description' => 'Guild nick of player <b>'.$player->getName().'</b> changed to <b>'.htmlentities($new_nick).'</b>.',
			'custom_buttons' => ''
		));
	}
}

if(!empty($errors)) {
	$twig->display('error_box.html.twig', array('errors' => $errors));
}

$twig->display('guilds.back_button.html.twig', array(
	'new_line' => true,
	'action' => getLink('guilds') . '/' . $guild->getName()
));
