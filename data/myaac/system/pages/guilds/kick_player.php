<?php
/**
 * Kick player from guild
 *
 * @package   MyAAC
 * @author    Gesior <jerzyskalski@wp.pl>
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

//set rights in guild
$guild_name = isset($_REQUEST['guild']) ? urldecode($_REQUEST['guild']) : null;
$name = isset($_REQUEST['name']) ? stripslashes($_REQUEST['name']) : null;

if(!$logged) {
	$errors[] = 'You are not logged in. You can\'t kick characters.';
}

if(!Validator::guildName($guild_name)) {
	$errors[] = Validator::getLastError();
}

if(!Validator::characterName($name)) {
	$errors[] = 'Invalid name format.';
}

if(empty($errors)) {
	$guild = new OTS_Guild();
	$guild->find($guild_name);
	if(!$guild->isLoaded()) {
		$errors[] = 'Guild with name <b>'.$guild_name.'</b> doesn\'t exist.';
	}
}

if(empty($errors)) {
	$rank_list = $guild->getGuildRanksList();
	$rank_list->orderBy('level', POT::ORDER_DESC);
	$guild_leader = false;
	$guild_vice = false;
	$account_players = $account_logged->getPlayers();
	foreach($account_players as $player) {
		$player_rank = $player->getRank();
		if($player_rank->isLoaded()) {
			foreach($rank_list as $rank_in_guild) {
				if($rank_in_guild->getId() == $player_rank->getId()) {
					$players_from_account_in_guild[] = $player->getName();
					if($player_rank->getLevel() > 1) {
						$guild_vice = true;
						$level_in_guild = $player_rank->getLevel();
					}
					if($guild->getOwner()->getId() == $player->getId()) {
						$guild_vice = true;
						$guild_leader = true;
					}
				}
			}
		}
	}
}

if(empty($errors)) {
	if(!$guild_leader && $level_in_guild < 3) {
		$errors[] = 'You are not a leader of guild <b>'.$guild_name.'</b>. You can\'t kick players.';
	}
}

if(empty($errors)) {
	$player = new OTS_Player();
	$player->find($name);
	if(!$player->isLoaded()) {
		$errors[] = 'Character <b>'.$name.'</b> doesn\'t exist.';
	}
	else
	{
		if($player->getRank()->isLoaded() && $player->getRank()->getGuild()->isLoaded() && $player->getRank()->getGuild()->getName() != $guild->getName()) {
			$errors[] = 'Character <b>'.$name.'</b> isn\'t from your guild.';
		}
	}
}

if(empty($errors)) {
	if($player->getRank()->isLoaded() && $player->getRank()->getLevel() >= $level_in_guild && !$guild_leader) {
		$errors[] = 'You can\'t kick character <b>'.$name.'</b>. Too high access level.';
	}
}

if(empty($errors)) {
	if($guild->getOwner()->getName() == $player->getName()) {
		$errors[] = 'It\'s not possible to kick guild owner!';
	}
}

if(!empty($errors)) {
	$twig->display('error_box.html.twig', array('errors' => $errors));
	$twig->display('guilds.back_button.html.twig', array(
		'action' => getLink('guilds') . '/' . $guild_name
	));
}
else
{
	if(isset($_REQUEST['todo']) && $_REQUEST['todo'] == 'save') {
		$player->setRank();

		$twig->display('success.html.twig', array(
			'title' => 'Kick player',
			'description' => 'Player with name <b>'.$player->getName().'</b> has been kicked from your guild.',
			'custom_buttons' => $twig->render('guilds.back_button.html.twig', array(
				'action' => getLink('guilds') . '/' . $guild_name
			))
		));
	}
	else {
		$twig->display('guilds.kick_player.html.twig', array(
			'player_name' => $player->getName(),
			'guild_name' => $guild->getName()
		));
	}
}
