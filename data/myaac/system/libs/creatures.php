<?php
/**
 * Creatures class
 *
 * @package   MyAAC
 * @author    Gesior <jerzyskalski@wp.pl>
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

require_once LIBS . 'items.php';
class Creatures {
	/**
	 * @var OTS_MonstersList
	 */
	private static $monstersList;
	private static $lastError = '';

	public static function loadFromXML($show = false) {
		global $db;

		try { $db->exec('DELETE FROM `' . TABLE_PREFIX . 'monsters`;'); } catch(PDOException $error) {}

		if($show) {
			echo '<h2>Reload monsters.</h2>';
			echo "<h2>All records deleted from table '" . TABLE_PREFIX . "monsters' in database.</h2>";
		}

		try {
			self::$monstersList = new OTS_MonstersList(config('data_path') . 'monster/');
		}
		catch(Exception $e) {
			self::$lastError = $e->getMessage();
			return false;
		}

        $items = [];
        Items::load();
        if (empty(Items::$items)) {
            if (Items::loadFromXML()) {
                success('Successfully loaded items.');
                // load again
                Items::load();
            }
        }

        if (empty(Items::$items)) {
            error('Fatal error. Please report to https://github.com/opentibiabr/myaac/issues');
            return false;
        }
        foreach ((array)Items::$items as $id => $item) {
            $items[$item['name']] = $id;
        }

		//$names_added must be an array
		$names_added[] = '';
		//add monsters
		foreach(self::$monstersList as $lol) {
			$monster = self::$monstersList->current();
			if(!$monster->loaded()) {
				if($show) {
					warning('Error while adding monster: ' . self::$monstersList->currentFile());
				}
				continue;
			}

			//load monster mana needed to summon/convince
			$mana = $monster->getManaCost();

			//load monster name
			$name = $monster->getName();
			//load monster health
			$health = $monster->getHealth();
			//load monster speed and calculate "speed level"
			$speed_ini = $monster->getSpeed();
			if($speed_ini <= 220) {
				$speed_lvl = 1;
			} else {
				$speed_lvl = ($speed_ini - 220) / 2;
			}
			//check "is monster use haste spell"
			$defenses = $monster->getDefenses();
			$use_haste = 0;
			foreach($defenses as $defense) {
				if($defense == 'speed') {
					$use_haste = 1;
				}
			}

			//load race
			$race = $monster->getRace();

			//load monster flags
			$flags = $monster->getFlags();
			if(!isset($flags['summonable']))
				$flags['summonable'] = '0';
			if(!isset($flags['convinceable']))
				$flags['convinceable'] = '0';

			$loot = $monster->getLoot();
			foreach($loot as &$item) {
				if(!Validator::number($item['id'])) {
					if(isset($items[$item['id']])) {
						$item['id'] = $items[$item['id']];
					}
				}
			}
			if(!in_array($name, $names_added)) {
				try {
					$db->insert(TABLE_PREFIX . 'monsters', array(
						'name' => $name,
						'mana' => empty($mana) ? 0 : $mana,
						'exp' => $monster->getExperience(),
						'health' => $health,
						'speed_lvl' => $speed_lvl,
						'use_haste' => $use_haste,
						'voices' => json_encode($monster->getVoices()),
						'immunities' => json_encode($monster->getImmunities()),
						'summonable' => $flags['summonable'] > 0 ? 1 : 0,
						'convinceable' => $flags['convinceable'] > 0 ? 1 : 0,
						'race' => $race,
						'loot' => json_encode($loot)
					));

					if($show) {
						success('Added: ' . $name . '<br/>');
					}
				}
				catch(PDOException $error) {
					if($show) {
						warning('Error while adding monster (' . $name . '): ' . $error->getMessage());
					}
				}

				$names_added[] = $name;
			}
		}

		return true;
	}

	public static function getMonstersList() {
		return self::$monstersList;
	}

	public static function getLastError() {
		return self::$lastError;
	}
}
