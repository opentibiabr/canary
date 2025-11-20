<?php
/**
 * Add rank
 *
 * @package   MyAAC
 * @author    Gesior <jerzyskalski@wp.pl>
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

$guild_name = isset($_REQUEST['guild']) ? urldecode($_REQUEST['guild']) : null;
$rank_name = isset($_REQUEST['rank_name']) ? $_REQUEST['rank_name'] : null;
if(!Validator::guildName($guild_name)) {
	$errors[] = Validator::getLastError();
}

if(empty($errors)) {
	if(!Validator::rankName($rank_name)) {
		$errors[] = 'Invalid rank name format.';
	}
	if(!$logged) {
		$errors[] = 'You are not logged.';
	}
	$guild = new OTS_Guild();
	$guild->find($guild_name);
	if(!$guild->isLoaded()) {
		$errors[] = 'Guild with name <b>'.$guild_name.'</b> doesn\'t exist.';
	}
	if(empty($errors)) {
		$guild_leader_char = $guild->getOwner();
		$rank_list = $guild->getGuildRanksList();
		$rank_list->orderBy('level', POT::ORDER_DESC);
		$guild_leader = false;
		$account_players = $account_logged->getPlayers();
		foreach($account_players as $player) {
			if($guild_leader_char->getId() == $player->getId()) {
				$guild_vice = true;
				$guild_leader = true;
				$level_in_guild = 3;
			}
		}
		if($guild_leader) {
			$new_rank = new OTS_GuildRank();
			$new_rank->setGuild($guild);
			$new_rank->setLevel(1);
			$new_rank->setName($rank_name);
			$new_rank->save();
			header("Location: ?subtopic=guilds&guild=".$guild->getName()."&action=manager");
			echo 'New rank added. Redirecting...';
		}
		else {
			$errors[] = 'You are not a leader of guild!';
		}
	}
	if(!empty($errors)) {
		$twig->display('error_box.html.twig', array('errors' => $errors));

		$twig->display('guilds.back_button.html.twig', array(
			'new_line' => true,
			'action' => '?subtopic=guilds&guild='.$guild_name.'&action=show'
		));
	}
}
else
{
	if(!empty($errors)) {
		$twig->display('error_box.html.twig', array('errors' => $errors));

		$twig->display('guilds.back_button.html.twig', array(
			'new_line' => true
		));
	}
}
