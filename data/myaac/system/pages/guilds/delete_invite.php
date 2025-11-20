<?php
/**
 * Delete invite
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
$name = stripslashes($_REQUEST['name']);

if(!$logged)
	$errors[] = 'You are not logged in. You can\'t delete invitations.';

if(!Validator::guildName($guild_name))
	$errors[] = Validator::getLastError();

if(!Validator::characterName($name))
	$errors[] = 'Invalid name format.';

if(empty($errors))
{
	$guild = new OTS_Guild();
	$guild->find($guild_name);
	if(!$guild->isLoaded())
		$errors[] = "Guild with name <b>" . $guild_name . "</b> doesn't exist.";
}

if(empty($errors))
{
	$rank_list = $guild->getGuildRanksList();
	$rank_list->orderBy('level', POT::ORDER_DESC);
	$guild_leader = false;
	$guild_vice = false;
	$account_players = $account_logged->getPlayers();
	foreach($account_players as $player)
	{
		$player_rank = $player->getRank();
		if($player_rank->isLoaded())
		{
			foreach($rank_list as $rank_in_guild)
			{
				if($rank_in_guild->getId() == $player_rank->getId())
				{
					$players_from_account_in_guild[] = $player->getName();
					if($player_rank->getLevel() > 1)
					{
						$guild_vice = true;
						$level_in_guild = $player_rank->getLevel();
					}
					if($guild->getOwner()->getId() == $player->getId())
					{
						$guild_vice = true;
						$guild_leader = true;
					}
				}
			}
		}
	}

	if(!$guild_vice)
		$errors[] = 'You are not a leader or vice leader of guild <b>' . $guild_name . '</b>.';
}
if(empty($errors))
{
	$player = new OTS_Player();
	$player->find($name);
	if(!$player->isLoaded())
		$errors[] = 'Player with name <b>' . $name . '</b> doesn\'t exist.';
}

if(empty($errors))
{
	include(SYSTEM . 'libs/pot/InvitesDriver.php');
	new InvitesDriver($guild);
	$invited_list = $guild->listInvites();
	if(count($invited_list) > 0)
	{
		$is_invited = false;
		foreach($invited_list as $invited)
			if($invited->getName() == $player->getName())
				$is_invited = true;
		if(!$is_invited)
			$errors[] = '<b>'.$player->getName().'</b> isn\'t invited to your guild.';
	}
	else
		$errors[] = 'No one is invited to your guild.';
}
if(!empty($errors))
{
	$twig->display('error_box.html.twig', array('errors' => $errors));

	$twig->display('guilds.back_button.html.twig', array('action' => '?subtopic=guilds&action=show&guild=' . $guild_name));
}
else
{
	if(isset($_REQUEST['todo']) && $_REQUEST['todo'] == 'save')
	{
		$guild->deleteInvite($player);
		$twig->display('success.html.twig', array(
			'title' => 'Deleted player invitation',
			'description' => 'Player with name <b>' . $player->getName() . '</b> has been deleted from invites list.',
			'custom_buttons' => $twig->render('guilds.back_button.html.twig', array('action' => '?subtopic=guilds&action=show&guild=' . $guild_name))
		));
	}
	else {
		$twig->display('guilds.delete_invite.html.twig', array(
			'player_name' => $player->getName(),
			'guild_name' => $guild->getName()
		));
	}
}
