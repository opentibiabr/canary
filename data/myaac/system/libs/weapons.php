<?php
/**
 * Weapons class
 *
 * @package   MyAAC
 * @author    Gesior <jerzyskalski@wp.pl>
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

class Weapons {
	private static $error = '';

	public static function loadFromXML($show = false)
	{
		global $config, $db;

		try {
			$db->exec("DELETE FROM `myaac_weapons`;");
		} catch (PDOException $error) {
		}

		$file_path = $config['data_path'] . 'weapons/weapons.xml';
		if (!file_exists($file_path)) {
			self::$error = 'Cannot load file ' . $file_path;
			return false;
		}

		$xml = new DOMDocument;
		$xml->load($file_path);

		foreach ($xml->getElementsByTagName('wand') as $weapon) {
			self::parseNode($weapon, $show);
		}
		foreach ($xml->getElementsByTagName('melee') as $weapon) {
			self::parseNode($weapon, $show);
		}
		foreach ($xml->getElementsByTagName('distance') as $weapon) {
			self::parseNode($weapon, $show);
		}

		return true;
	}

	public static function parseNode($node, $show = false) {
		global $config, $db;

		$id = (int)$node->getAttribute('id');
		$vocations_ids = array_flip($config['vocations']);
		$level = (int)$node->getAttribute('level');
		$maglevel = (int)$node->getAttribute('maglevel');

		$vocations = array();
		foreach($node->getElementsByTagName('vocation') as $vocation) {
			$show = $vocation->getAttribute('showInDescription');
			if(!empty($vocation->getAttribute('id')))
				$voc_id = $vocation->getAttribute('id');
			else {
				$voc_id = $vocations_ids[$vocation->getAttribute('name')];
			}

			$vocations[$voc_id] = strlen($show) == 0 || $show != '0';
		}

		$exist = $db->query('SELECT `id` FROM `' . TABLE_PREFIX . 'weapons` WHERE `id` = ' . $id);
		if($exist->rowCount() > 0) {
			if($show) {
				warning('Duplicated weapon with id: ' . $id);
			}
		}
		else {
			$db->insert(TABLE_PREFIX . 'weapons', array('id' => $id, 'level' => $level, 'maglevel' => $maglevel, 'vocations' => json_encode($vocations)));
		}
	}

	public static function getError() {
		return self::$error;
	}
}
