<?php

// add new item_id field for runes
if(!$db->hasColumn(TABLE_PREFIX . 'spells', 'item_id'))
	$db->query("ALTER TABLE `" . TABLE_PREFIX . "spells` ADD `item_id` INT(11) NOT NULL DEFAULT 0 AFTER `conjure_count`;");

// change unique index from spell to name
$db->query("ALTER TABLE `" . TABLE_PREFIX . "spells` DROP INDEX `spell`;");
$db->query("ALTER TABLE `" . TABLE_PREFIX . "spells` ADD UNIQUE INDEX (`name`);");

// change comment of spells.type
$db->query("ALTER TABLE `" . TABLE_PREFIX . "spells` MODIFY `type` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '1 - instant, 2 - conjure, 3 - rune';");

// new items table
if(!$db->hasTable(TABLE_PREFIX . 'items'))
$db->query("
CREATE TABLE `" . TABLE_PREFIX . "items`
(
	`id` INT(11) NOT NULL,
	`article` VARCHAR(5) NOT NULL DEFAULT '',
	`name` VARCHAR(50) NOT NULL DEFAULT '',
	`plural` VARCHAR(50) NOT NULL DEFAULT '',
	`attributes` VARCHAR(500) NOT NULL DEFAULT '',
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;
");

// new weapons table
if(!$db->hasTable(TABLE_PREFIX . 'weapons'))
$db->query("
CREATE TABLE `" . TABLE_PREFIX . "weapons`
(
	`id` INT(11) NOT NULL,
	`level` INT(11) NOT NULL DEFAULT 0,
	`maglevel` INT(11) NOT NULL DEFAULT 0,
	`vocations` VARCHAR(100) NOT NULL DEFAULT '',
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;
");

// modify vocations to support json data
$db->query("ALTER TABLE `" . TABLE_PREFIX . "spells` MODIFY `vocations` VARCHAR(100) NOT NULL DEFAULT '';");
$query = $db->query('SELECT `id`, `vocations` FROM `' . TABLE_PREFIX . 'spells`');
foreach($query->fetchAll() as $spell) {
	$tmp = explode(',', $spell['vocations']);
	foreach($tmp as &$v) {
		$v = (int)$v;
	}
	$db->update(TABLE_PREFIX . 'spells', array('vocations' => json_encode($tmp)), array('id' => $spell['id']));
}
?>