<?php
/**
 * Delete rank
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
$rank_to_delete = isset($_REQUEST['rankid']) ? (int) $_REQUEST['rankid'] : null;

if(!Validator::guildName($guild_name)) {
	$guild_errors[] = Validator::getLastError();
}
if(empty($guild_errors)) {
	$guild = new OTS_Guild();
	$guild->find($guild_name);
	if(!$guild->isLoaded()) {
		$guild_errors[] = 'Guild with name <b>'.$guild_name.'</b> doesn\'t exist.';
	}
}
if(empty($guild_errors)) {
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
			$rank = new OTS_GuildRank();
			$rank->load($rank_to_delete);
			if(!$rank->isLoaded()) {
				$guild_errors2[] = 'Rank with ID '.$rank_to_delete.' doesn\'t exist.';
			}
			else
			{
				if($rank->getGuild()->getId() != $guild->getId()) {
					$guild_errors2[] = 'Rank with ID '.$rank_to_delete.' isn\'t from your guild.';
				}
				else
				{
					if(count($rank_list) < 2) {
						$guild_errors2[] = 'You have only 1 rank in your guild. You can\'t delete this rank.';
					}
					else
					{
						if($db->hasColumn('players', 'rank_id'))
							$players_with_rank = $db->query('SELECT `id`, `rank_id` FROM `players` WHERE `rank_id` = ' . $rank->getId() . ' AND `deleted` = 0;');
						else
							$players_with_rank = $db->query('SELECT `players`.`id` as `id`, `' . GUILD_MEMBERS_TABLE . '`.`rank_id` as `rank_id` FROM `players`, `' . GUILD_MEMBERS_TABLE . '` WHERE `' . GUILD_MEMBERS_TABLE . '`.`rank_id` = ' . $rank->getId() . ' AND `players`.`id` = `' . GUILD_MEMBERS_TABLE . '`.`player_id` ORDER BY `name`;');

						$players_with_rank_number = $players_with_rank->rowCount();
						if($players_with_rank_number > 0) {
							foreach($rank_list as $checkrank) {
								if($checkrank->getId() != $rank->getId()) {
									if($checkrank->getLevel() <= $rank->getLevel()) {
										$new_rank = $checkrank;
									}
								}
							}

							if(empty($new_rank)) {
								$new_rank = new OTS_GuildRank();
								$new_rank->setGuild($guild);
								$new_rank->setLevel($rank->getLevel());
								$new_rank->setName('New Rank level '.$rank->getLevel());
								$new_rank->save();
							}

							foreach($players_with_rank as $player_in_guild) {
								$player = new OTS_Player();
								$player->load($player_in_guild['id']);
								if ($player->isLoaded())
									$player->setRank($new_rank);
							}
						}
						$rank->delete();
						$saved = true;
					}
				}
			}
			if($saved) {
				$twig->display('success.html.twig', array(
					'title' => 'Rank Deleted',
					'description' => 'Rank <b>'.$rank->getName().'</b> has been deleted. Players with this rank has now other rank.',
					'custom_buttons' => ''
				));
			} else {
				$twig->display('error_box.html.twig', array('errors' => $guild_errors2));
			}

			$twig->display('guilds.back_button.html.twig', array(
				'new_line' => true,
				'action' => '?subtopic=guilds&guild='.$guild->getName().'&action=manager'
			));
		}
		else
		{
			$guild_errors[] = 'You are not a leader of guild!';
		}
	}
	else
	{
		$guild_errors[] = 'You are not logged. You can\'t manage guild.';
	}
}
if(!empty($guild_errors)) {
	$twig->display('error_box.html.twig', array('errors' => $guild_errors));

	$twig->display('guilds.back_button.html.twig', array(
		'new_line' => true,
		'action' => '?subtopic=guilds'
	));
}
