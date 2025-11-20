<?php
/**
 * Spells class
 *
 * @package   MyAAC
 * @author    Gesior <jerzyskalski@wp.pl>
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

class Spells
{
	/**
	 * @var null
	 */
	private static $spellsList = null;
	/**
	 * @var string
	 */
	private static $lastError = '';

	// 1 - attack, 2 - healing, 3 - summon, 4 - supply, 5 - support

	/**
	 * @param $tGroup
	 *
	 * @return int|void
	 */
	public static function loadGroup($tGroup)
	{
		switch ($tGroup) {
			case 'attack':
				return 1;
			case 'healing':
				return 2;
			case 'summon':
				return 3;
			case 'supply':
				return 4;
			case 'support':
				return 5;
		}
	}

	/**
	 * @param false $show
	 *
	 * @return bool
	 */
	public static function loadFromXML($show = false)
	{
		//global $config, $db;

		self::$lastError = 'Utilize o arquivo "data-json/spells.json" para carregar as spells..';

		return;
		try {
			$db->exec('DELETE FROM `' . TABLE_PREFIX . 'spells`;');
		} catch (PDOException $error) {
		}

		if ($show) {
			echo '<h2>Reload spells.</h2>';
			echo '<h2>All records deleted from table <b>' . TABLE_PREFIX . 'spells</b> in database.</h2>';
		}

		try {
			self::$spellsList = new OTS_SpellsParseLua($config['data_path'] . 'scripts/spells');
		} catch (Exception $e) {
			self::$lastError = $e->getMessage();

			return false;
		}

		//add conjure spells
		$listArray = self::$spellsList->get();

		if ($show) {
			echo '<h3>Conjure:</h3>';
		}

		foreach ($listArray['conjuring'] as $spellname) {
			if (isset($spellname['ignore'])) {
				continue;
			}

			if (empty($spellname)) {
				continue;
			}

			try {
				$db->insert(TABLE_PREFIX . 'spells', [
					'name'          => ucwords($spellname['name'] ?? '') . ' Conjure',
					'words'         => $spellname['words'] ?? '',
					'type'          => 2,
					'mana'          => $spellname['mana'] ?? 0,
					'level'         => $spellname['level'] ?? 0,
					'maglevel'      => $spellname['magicLevel'] ?? 0,
					'soul'          => $spellname['soul'] ?? 0,
					'premium'       => boolval($spellname['isPremium'] ?? false) === true ? 1 : 0,
					'vocations'     => json_encode($spellname['vocation'] ?? []),
					'conjure_count' => null,
					'conjure_id'    => null,
					'reagent'       => null,
					'item_id'       => $spellname['runeId'] ?? null,
					'hidden'        => $spellname['hidden'],
				]);

				if ($show) {
					success('Added: ' . $spellname['name'] . '<br/>');
				}
			} catch (PDOException $error) {
				if ($show) {
					warning('Error while adding spell (' . $spellname['name'] . '): ' . $error->getMessage());
				}
			}
		}

		// add instant spells
		if ($show) {
			echo '<h3>Instant:</h3>';
		}

		foreach ($listArray['instant'] as $spellname) {
			if (isset($spellname['ignore'])) {
				continue;
			}

			if (empty($spellname)) {
				continue;
			}

			try {
				$db->insert(TABLE_PREFIX . 'spells', [
					'name'          => ucwords($spellname['name'] ?? '') . ' Spell',
					'words'         => $spellname['words'] ?? '',
					'type'          => 1,
					'mana'          => $spellname['mana'] ?? 0,
					'level'         => $spellname['level'] ?? 0,
					'maglevel'      => $spellname['magicLevel'] ?? 0,
					'soul'          => $spellname['soul'] ?? 0,
					'premium'       => boolval($spellname['isPremium'] ?? false) === true ? 1 : 0,
					'vocations'     => json_encode($spellname['vocation'] ?? []),
					'conjure_count' => null,
					'conjure_id'    => null,
					'reagent'       => null,
					'hidden'        => $spellname['hidden'],
				]);

				if ($show) {
					success('Added: ' . $spellname['name'] . '<br/>');
				}
			} catch (PDOException $error) {
				if ($show) {
					warning('Error while adding spell (' . $spellname['name'] . '): ' . $error->getMessage());
				}
			}
		}

		// add runes
		if ($show) {
			echo '<h3>Runes:</h3>';
		}

		foreach ($listArray['runes'] as $spellname) {
			if (isset($spellname['ignore'])) {
				continue;
			}

			if (empty($spellname)) {
				continue;
			}

			try {
				$db->insert(TABLE_PREFIX . 'spells', [
					'name'          => ucwords($spellname['name'] ?? ''),
					'words'         => $spellname['words'] ?? '',
					'type'          => 3,
					'mana'          => $spellname['mana'] ?? 0,
					'level'         => $spellname['level'] ?? 0,
					'maglevel'      => $spellname['magicLevel'] ?? 0,
					'soul'          => $spellname['soul'] ?? 0,
					'premium'       => boolval($spellname['isPremium'] ?? false) === true ? 1 : 0,
					'vocations'     => json_encode($spellname['vocation'] ?? []),
					'conjure_count' => null,
					'conjure_id'    => null,
					'reagent'       => null,
					'item_id'       => $spellname['runeId'] ?? null,
					'hidden'        => $spellname['hidden'],
				]);

				if ($show) {
					success('Added: ' . $spellname['name'] . '<br/>');
				}
			} catch (PDOException $error) {
				if ($show) {
					warning('Error while adding spell (' . $spellname['name'] . '): ' . $error->getMessage());
				}
			}
		}

		return true;
	}

	/**
	 * @return null
	 */
	public static function getSpellsList()
	{
		return self::$spellsList;
	}

	/**
	 * @return string
	 */
	public static function getLastError()
	{
		return self::$lastError;
	}
}
