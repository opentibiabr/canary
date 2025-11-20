<?php

// change monsters.file_path field to loot
if($db->hasColumn(TABLE_PREFIX . 'monsters', 'file_path')) {
	$db->query("ALTER TABLE `" . TABLE_PREFIX . "monsters` CHANGE `file_path` `loot` VARCHAR(5000);");
}

// update loot to empty string
$db->query("UPDATE `" . TABLE_PREFIX . "monsters` SET `loot` = '';");

// drop monsters.gfx_name field
$db->query("ALTER TABLE `" . TABLE_PREFIX . "monsters` DROP COLUMN `gfx_name`;");

// rename hide_creature to hidden
if($db->hasColumn(TABLE_PREFIX . 'monsters', 'hide_creature')) {
	$db->query("ALTER TABLE `" . TABLE_PREFIX . "monsters` CHANGE `hide_creature` `hidden` TINYINT(1) NOT NULL DEFAULT 0;");
}
?>