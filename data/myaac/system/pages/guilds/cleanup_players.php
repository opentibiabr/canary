<?php
/**
 * Cleanup players
 *
 * @package   MyAAC
 * @author    Gesior <jerzyskalski@wp.pl>
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

if(!$logged)
{
	echo "You are not logged in.";
	$twig->display('guilds.back_button.html.twig');
	return;
}

if(admin())
{
	$players_list = new OTS_Players_List();
	$players_list->init();
}
else
	$players_list = $account_logged->getPlayersList();

if(count($players_list) > 0)
{
	foreach($players_list as $player)
	{
		$player_rank = $player->getRank();
		if($player_rank->isLoaded())
		{
			if($player_rank->isLoaded())
			{
				$rank_guild = $player_rank->getGuild();
				if(!$rank_guild->isLoaded())
				{
					$player->setRank();
					$player->setGuildNick();
					$changed_ranks_of[] = $player->getName();
					$deleted_ranks[] = 'ID: '.$player_rank->getId().' - '.$player_rank->getName();
					$player_rank->delete();
				}
			}
			else
			{
				$player->setRank();
				$player->setGuildNick('');
				$changed_ranks_of[] = $player->getName();
			}

		}
	}
	echo "<b>Deleted ranks (this ranks guilds doesn't exist [bug fix]):</b>";
	if(!empty($deleted_ranks))
		foreach($deleted_ranks as $rank)
			echo "<li>".$rank;
	echo "<BR /><BR /><b>Changed ranks of players (rank or guild of rank doesn't exist [bug fix]):</b>";
	if(!empty($changed_ranks_of))
		foreach($changed_ranks_of as $name)
			echo "<li>".$name;
}
else
	echo "0 players found.";

$twig->display('guilds.back_button.html.twig');
