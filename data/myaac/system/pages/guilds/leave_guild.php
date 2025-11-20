<?php
/**
 * Leave guild
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
$guild_name = isset($_REQUEST['guild']) ? urldecode($_REQUEST['guild']) : NULL;
$name = isset($_REQUEST['name']) ? stripslashes($_REQUEST['name']) : NULL;
if(!$logged) {
	$errors[] = "You are not logged in. You can't leave guild.";
}

if(!Validator::guildName($guild_name)) {
	$errors[] = Validator::getLastError();
}

if(empty($errors)) {
	$guild = new OTS_Guild();
	$guild->find($guild_name);
	if(!$guild->isLoaded()) {
		$errors[] = "Guild with name <b>" . $guild_name . "</b> doesn't exist.";
	}
}

$array_of_player_ig = array();
if(empty($errors)) {
	$guild_owner_name = $guild->getOwner()->getName();
	if(isset($_REQUEST['todo']) && $_REQUEST['todo'] == 'save') {
		if(!Validator::characterName($name)) {
			$errors[] = 'Invalid name format.';
		}

		if(empty($errors)) {
			$player = new OTS_Player();
			$player->find($name);
			if(!$player->isLoaded()) {
				$errors[] = "Character <b>" . $name . "</b> doesn't exist.";
			}
			else {
				if($player->getAccount()->getId() != $account_logged->getId()) {
					$errors[] = "Character <b>" . $name . "</b> isn't from your account!";
				}
			}
		}

		if(empty($errors)) {
			$player_loaded_rank = $player->getRank();
			if($player_loaded_rank->isLoaded()) {
				if($player_loaded_rank->getGuild()->getName() != $guild->getName()) {
					$errors[] = "Character <b>" . $name . "</b> isn't from guild <b>" . $guild->getName() . "</b>.";
				}
			}
			else {
				$errors[] = "Character <b>" . $name . "</b> isn't in any guild.";
			}
		}

		if(empty($errors)) {
			if($guild_owner_name == $player->getName()) {
				$errors[] = "You can't leave guild. You are an owner of guild.";
			}
		}
	}
	else
	{
		$account_players = $account_logged->getPlayers();
		foreach($account_players as $player_fac) {
			$player_rank = $player_fac->getRank();
			if($player_rank->isLoaded()) {
				if($player_rank->getGuild()->getId() == $guild->getId()) {
					if($guild_owner_name != $player_fac->getName()) {
						$array_of_player_ig[] = $player_fac->getName();
					}
				}
			}
		}
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
			'title' => 'Leave guild',
			'description' => 'Player with name <b>'.$player->getName().'</b> leaved guild <b>'.$guild->getName().'</b>.',
			'custom_buttons' => $twig->render('guilds.back_button.html.twig', array(
				'action' => getLink('guilds') . '/' . $guild_name
			))
		));
	}
	else
	{
		sort($array_of_player_ig);

		$twig->display('guilds.leave_guild.html.twig', array(
			'players' => $array_of_player_ig,
			'guild_name' => $guild_name
		));
	}
}
