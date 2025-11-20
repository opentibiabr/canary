<?php

if($db->hasColumn(TABLE_PREFIX . 'spells', 'spell')) {
	$db->exec('ALTER TABLE `' . TABLE_PREFIX . "spells` MODIFY `spell` VARCHAR(255) NOT NULL DEFAULT '';");
}

if($db->hasColumn(TABLE_PREFIX . 'spells', 'words')) {
	$db->exec('ALTER TABLE `' . TABLE_PREFIX . "spells` MODIFY `words` VARCHAR(255) NOT NULL DEFAULT '';");
}

if(!$db->hasColumn(TABLE_PREFIX . 'spells', 'conjure_id')) {
	$db->exec('ALTER TABLE `' . TABLE_PREFIX . 'spells` ADD `conjure_id` INT(11) NOT NULL DEFAULT 0 AFTER `soul`;');
}

if(!$db->hasColumn(TABLE_PREFIX . 'spells', 'reagent')) {
	$db->exec('ALTER TABLE `' . TABLE_PREFIX . 'spells` ADD `reagent` INT(11) NOT NULL DEFAULT 0 AFTER `conjure_count`;');
}
