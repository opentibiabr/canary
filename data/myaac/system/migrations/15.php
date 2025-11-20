<?php

// add new forum.guild and forum.access fields
if(!$db->hasColumn(TABLE_PREFIX . 'forum_boards', 'guild')) {
	$db->query("ALTER TABLE `" . TABLE_PREFIX . "forum_boards` ADD `guild` TINYINT(1) NOT NULL DEFAULT 0 AFTER `closed`;");
}

if(!$db->hasColumn(TABLE_PREFIX . 'forum_boards', 'access')) {
	$db->query("ALTER TABLE `" . TABLE_PREFIX . "forum_boards` ADD `access` TINYINT(1) NOT NULL DEFAULT 0 AFTER `guild`;");
}
?>