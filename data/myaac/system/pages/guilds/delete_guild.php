<?php
/**
 * Delete guild
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
if(!Validator::guildName($guild_name)) {
	$errors[] = Validator::getLastError();
}

if(empty($errors)) {
	$guild = new OTS_Guild();
	$guild->find($guild_name);
	if(!$guild->isLoaded()) {
		$errors[] = 'Guild with name <b>'.$guild_name.'</b> doesn\'t exist.';
	}
}

if(empty($errors)) {
	if($logged) {
		$guild_leader_char = $guild->getOwner();
		$rank_list = $guild->getGuildRanksList();
		$rank_list->orderBy('level', POT::ORDER_DESC);
		$guild_leader = false;
		$account_players = $account_logged->getPlayers();

		foreach($account_players as $player) {
			if($guild->getOwner()->getId() == $player->getId()) {
				$guild_vice = true;
				$guild_leader = true;
				$level_in_guild = 3;
			}
		}

		if($guild_leader) {
			$saved = false;

			if(isset($_POST['todo']) && $_POST['todo'] == 'save') {
				delete_guild($guild->getId());
				$saved = true;
			}

			if($saved) {
				$twig->display('success.html.twig', array(
					'title' => 'Guild Deleted',
					'description' => 'Guild with name <b>'.$guild_name.'</b> has been deleted.',
					'custom_buttons' => $twig->render('guilds.back_button.html.twig')
				));
			}
			else {
				$twig->display('guilds.delete_guild.html.twig', array(
					'guild' => $guild
				));
			}
		}
		else {
			$errors[] = 'You are not a leader of guild!';
		}
	}
	else {
		$errors[] = 'You are not logged. You can\'t manage guild.';
	}
}

if(!empty($errors)) {
	$twig->display('error_box.html.twig', array('errors' => $errors));

	$twig->display('guilds.back_button.html.twig', array(
		'new_line' => true
	));
}
