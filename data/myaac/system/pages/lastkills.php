<?php
/**
 * Last kills
 *
 * @package   MyAAC
 * @author    Gesior <jerzyskalski@wp.pl>
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');
$title = 'Last Kills';

$last_kills = array();
$players_deaths_count = 0;

$tmp = null;
if($cache->enabled() && $cache->fetch('last_kills', $tmp)) {
	$last_kills = unserialize($tmp);
}
else {
	if($db->hasTable('player_killers')) // tfs 0.3
	{
		$players_deaths = $db->query('SELECT `player_deaths`.`id`, `player_deaths`.`date`, `player_deaths`.`level`, `players`.`name`' . ($db->hasColumn('players', 'world_id') ? ', `players`.`world_id`' : '') . ' FROM `player_deaths` LEFT JOIN `players` ON `player_deaths`.`player_id` = `players`.`id` ORDER BY `date` DESC LIMIT 0, ' . $config['last_kills_limit']);

		if(!empty($players_deaths)) {
			foreach($players_deaths as $death) {
				$players_deaths_count++;
				$killers_string = getPlayerLink($death['name']) . ' ';
				$killer_name = '';

				$killers = $db->query("SELECT environment_killers.name AS monster_name, players.name AS player_name, players.deleted AS player_exists FROM killers LEFT JOIN environment_killers ON killers.id = environment_killers.kill_id LEFT JOIN player_killers ON killers.id = player_killers.kill_id LEFT JOIN players ON players.id = player_killers.player_id WHERE killers.death_id = '" . $death['id'] . "' ORDER BY killers.final_hit DESC, killers.id ASC")->fetchAll();

				$i = 0;
				$count = count($killers);
				foreach($killers as $killer) {
					$i++;
					if($killer['player_name'] != "") {
						if($i == 1) {
							if($count <= 4)
								$killers_string .= 'killed';
							else if($count > 4 and $count < 10)
								$killers_string .= 'slain';
							else if($count > 9 and $count < 15)
								$killers_string .= 'crushed';
							else if($count > 14 and $count < 20)
								$killers_string .= 'eliminated';
							else if($count > 19)
								$killers_string .= 'annihilated';
							$killers_string .= ' at level <b>' . $death['level'] . '</b> ';
						} else if($i == $count)
							$killers_string .= ' and';
						else
							$killers_string .= ',';

						$killers_string .= ' by ';
						if($killer['monster_name'] != '')
							$killers_string .= $killer['monster_name'] . ' summoned by ';

						if($killer['player_exists'] == 0)
							$killers_string .= getPlayerLink($killer['player_name']);
					} else {
						if($i == 1)
							$killers_string .= 'died at level <b>' . $death['level'] . '</b>';
						else if($i == $count)
							$killers_string .= ' and';
						else
							$killers_string .= ',';

						$killers_string .= ' by ' . $killer['monster_name'];
					}
				}

				$killers_string .= '.';

				$last_kills[] = array(
					'id' => $players_deaths_count,
					'time' => $death['date'],
					'killers_string' => $killers_string,
					'world_id' => isset($config['worlds'][(int)$death['world_id']]) ? $config['worlds'][(int)$death['world_id']] : null,
				);
			}
		}
	} else {
		//$players_deaths = $db->query("SELECT `p`.`name` AS `victim`, `player_deaths`.`killed_by` as `killed_by`, `player_deaths`.`time` as `time`, `player_deaths`.`is_player` as `is_player`, `player_deaths`.`level` as `level` FROM `player_deaths`, `players` as `d` INNER JOIN `players` as `p` ON player_deaths.player_id = p.id WHERE player_deaths.`is_player`='1' ORDER BY `time` DESC LIMIT " . $config['last_kills_limit'] . ";");

		$players_deaths = $db->query("SELECT `p`.`name` AS `victim`, `d`.`killed_by` as `killed_by`, `d`.`time` as `time`, `d`.`level`, `d`.`is_player` FROM `player_deaths` as `d` INNER JOIN `players` as `p` ON d.player_id = p.id ORDER BY `time` DESC LIMIT " . $config['last_kills_limit'] . ";");
		if(!empty($players_deaths)) {
			foreach($players_deaths as $death) {
				$players_deaths_count++;
				$killers_string = '';

				$killers_string .= getPlayerLink($death['victim']) . ' died at level <strong>' . $death['level'] . '</strong> by ';
				if($death['is_player'] == '1')
					$killers_string .= getPlayerLink($death['killed_by']);
				else
					$killers_string .= $death['killed_by'];

				$killers_string .= '.';

				$last_kills[] = array(
					'id' => $players_deaths_count,
					'time' => $death['time'],
					'killers_string' => $killers_string,
				);
			}
		}
	}

	if($cache->enabled()) {
		$cache->set('last_kills', serialize($last_kills), 120);
	}
}

$twig->display('lastkills.html.twig', array(
	'lastkills' => $last_kills
));
